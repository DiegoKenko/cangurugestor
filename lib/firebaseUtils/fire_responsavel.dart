import 'package:cangurugestor/model/paciente.dart';
import 'package:cangurugestor/model/responsavel.dart';
import 'package:cangurugestor/firebaseUtils/fire_login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreResponsavel {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirestoreLogin firestoreLogin = FirestoreLogin();

  Future<Responsavel> create(Responsavel responsavel) async {
    var doc =
        await firestore.collection('responsaveis').add(responsavel.toMap());
    responsavel.id = doc.id;
    FirestoreLogin().atualizaLoginResponsavel(responsavel);
    return responsavel;
  }

  Future<Responsavel> get(String id) async {
    Responsavel responsavel = Responsavel();
    if (id.isEmpty) {
      return responsavel;
    }
    await firestore.collection('responsaveis').doc(id).get().then((doc) {
      if (doc.data() != null) {
        responsavel = Responsavel.fromMap(doc.data()!);
        responsavel.id = doc.id;
      }
    });
    return responsavel;
  }

  Future<void> update(Responsavel responsavel) async {
    await firestore
        .collection('responsaveis')
        .doc(responsavel.id)
        .update(responsavel.toMap());

    FirestoreLogin().atualizaLoginResponsavel(responsavel);
  }

  Future<List<Paciente>> todosPacientesResponsavel(
    Responsavel responsavel,
  ) async {
    var snap = await firestore
        .collection('pacientes')
        .where('idResponsavel', isEqualTo: responsavel.id)
        .get();
    return snap.docs.map((e) {
      Paciente paciente = Paciente.fromMap(e.data());
      paciente.id = e.id;
      return paciente;
    }).toList();
  }

  Future<void> delete(Responsavel responsavel) async {
    await firestore.collection('responsaveis').doc(responsavel.id).delete();
  }
}
