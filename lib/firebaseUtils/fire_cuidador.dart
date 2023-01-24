import 'package:cangurugestor/model/cuidador.dart';
import 'package:cangurugestor/model/gestor.dart';
import 'package:cangurugestor/model/paciente.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreCuidador {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<Cuidador> create(Cuidador cuidador) async {
    var doc = await firestore.collection('cuidadores').add(cuidador.toMap());
    cuidador.id = doc.id;
    return cuidador;
  }

  Future<Cuidador> read(String id) async {
    var doc = await firestore.collection('cuidadores').doc(id).get();
    if (doc.data() != null) {
      Cuidador cuidador = Cuidador.fromMap(doc.data()!);
      cuidador.id = doc.id;
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

  Future<List<Paciente>> todosPacientesCuidador(
      String idCuidador, Gestor gestor) async {
    List<Paciente> pacientes = [];
    QuerySnapshot<Map<String, dynamic>> doc =
        await firestore.collection('cuidadores').get();
    for (var element in doc.docs) {
      DocumentSnapshot<Map<String, dynamic>> gestorDoc =
          await firestore.collection('gestores').doc(element.id).get();
      List<String> idPacientesGestor = gestorDoc.data()!['idPacientes'];
      if (idPacientesGestor.contains(idCuidador)) {
        DocumentSnapshot<Map<String, dynamic>> pacienteDoc =
            await firestore.collection('pacientes').doc(element.id).get();

        Paciente paciente = Paciente.fromMap(pacienteDoc.data()!);
        paciente.id = pacienteDoc.id;
        pacientes.add(paciente);
      }
    }
    return pacientes;
  }
}
