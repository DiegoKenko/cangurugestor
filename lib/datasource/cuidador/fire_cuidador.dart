import 'package:cangurugestor/datasource/login/fire_login.dart';
import 'package:cangurugestor/model/cuidador.dart';
import 'package:cangurugestor/model/paciente.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreCuidador {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;


  Future<Cuidador> get(String id) async {
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

  Future<void> update(Cuidador cuidador) async {
    await firestore
        .collection('cuidadores')
        .doc(cuidador.id)
        .update(cuidador.toMap());
    await FirestoreLogin().atualizaLoginCuidador(cuidador);
  }

  Future<void> delete(Cuidador cuidador) async {
    await firestore.collection('cuidadores').doc(cuidador.id).delete();
  }

  Future<List<Paciente>> todosPacientesCuidador(Cuidador cuidador) async {
    List<Paciente> pacientes = [];
    if (cuidador.id.isEmpty) {
      return pacientes;
    }
    var snap = await firestore
        .collection('pacientes')
        .where('idCuidadores', arrayContains: cuidador.id)
        .get();

    return snap.docs.map((e) {
      Paciente paciente = Paciente.fromMap(e.data());
      paciente.id = e.id;
      return paciente;
    }).toList();
  }
}
