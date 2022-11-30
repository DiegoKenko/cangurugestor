import 'package:cangurugestor/classes/cuidador.dart';
import 'package:cangurugestor/classes/login.dart';
import 'package:cangurugestor/classes/paciente.dart';
import 'package:cangurugestor/firebaseUtils/fire_login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreCuidador {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirestoreLogin firestoreLogin = FirestoreLogin();
  Future<Cuidador> incluirCuidador(Cuidador cuidador) async {
    var cuid = await firestore.collection('cuidadores').add(cuidador.toMap());
    cuidador.id = cuid.id;

    firestoreLogin.atualizaLogin(Login(
        colecao: 'cuidadores',
        cpf: cuidador.cpf,
        doc: cuid.id,
        funcao: 'cuidador',
        senha: cuidador.senha,
        ativo: cuidador.ativo));
    return cuidador;
  }

  atualizarCuidador(Cuidador cuidador) {
    firestore.collection('cuidadores').doc(cuidador.id).get().then(
      (snapshot) {
        if (snapshot.exists) {
          snapshot.reference.update(cuidador.toMap());
          firestoreLogin.atualizaLogin(Login(
              colecao: 'cuidadores',
              cpf: cuidador.cpf,
              doc: snapshot.reference.id,
              funcao: 'cuidador',
              senha: cuidador.senha,
              ativo: cuidador.ativo));
        }
      },
    );
  }

  excluirCuidador(String idCuidador) {
    firestore.collection('cuidadores').doc(idCuidador).delete();
    firestoreLogin.deleteLogin(idCuidador);
  }

  Stream<List<Paciente>> todosPacientesCuidadorStream(
      String responsavelId, String cuidadorId) {
    return firestore
        .collection('pacientes')
        .where('cuidadores', arrayContains: cuidadorId)
        .snapshots()
        .map((event) =>
            event.docs.map((e) => Paciente.fromMap(e.data())).toList());
  }

  incluirPacienteCuidador(String idPaciente, String idCuidador) {
    if (idPaciente.isNotEmpty && idCuidador.isNotEmpty) {
      firestore.collection('pacientes').doc(idPaciente).update({
        'cuidadores': FieldValue.arrayUnion([idCuidador]),
      });
      firestore.collection('cuidadores').doc(idCuidador).update({
        'pacientes': FieldValue.arrayUnion(
          [idPaciente],
        )
      });
    }
  }

  excluirPacienteCuidador(String idPaciente, String idCuidador) {
    if (idPaciente.isNotEmpty && idCuidador.isNotEmpty) {
      firestore.collection('pacientes').doc(idPaciente).set({
        'cuidadores': FieldValue.arrayRemove([idCuidador]),
      });
      firestore.collection('cuidadores').doc(idCuidador).update({
        'pacientes': FieldValue.arrayRemove(
          [idPaciente],
        )
      });
    }
  }
}
