import 'package:cangurugestor/firebaseUtils/fire_login.dart';
import 'package:cangurugestor/model/cuidador.dart';
import 'package:cangurugestor/model/paciente.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreCuidador {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<Cuidador> create(Cuidador cuidador) async {
    var doc = await firestore.collection('cuidadores').add(cuidador.toMap());
    cuidador.id = doc.id;
    FirestoreLogin().atualizaLoginCuidador(cuidador);
    return cuidador;
  }

  Future<Cuidador> read(String id) async {
    var doc = await firestore.collection('cuidadores').doc(id).get();
    if (doc.data() != null) {
      Cuidador cuidador = Cuidador.fromMap(doc.data()!);
      cuidador.id = doc.id;
      FirestoreLogin().atualizaLoginCuidador(cuidador);
      return cuidador;
    } else {
      return Cuidador();
    }
  }

  Future<Cuidador> update(Cuidador cuidador) async {
    await firestore
        .collection('cuidadores')
        .doc(cuidador.id)
        .update(cuidador.toMap());
    return cuidador;
  }

  Future<void> delete(Cuidador cuidador) async {
    await firestore.collection('cuidadores').doc(cuidador.id).delete();
  }

  Future<List<Paciente>> todosPacientesCuidador(Cuidador cuidador) async {
    List<Paciente> pacientes = [];
    if (cuidador.id.isEmpty) {
      return pacientes;
    }
    DocumentSnapshot<Map<String, dynamic>> doc =
        await firestore.collection('cuidadores').doc(cuidador.id).get();
    for (String element in doc.data()!['idPacientes']) {
      if (element.isNotEmpty) {
        DocumentSnapshot<Map<String, dynamic>> pacienteDoc =
            await firestore.collection('pacientes').doc(element).get();
        if (pacienteDoc.data() != null) {
          Paciente paciente = Paciente.fromMap(pacienteDoc.data()!);
          paciente.id = pacienteDoc.id;
          pacientes.add(paciente);
        }
      }
    }
    return pacientes;
  }
}
