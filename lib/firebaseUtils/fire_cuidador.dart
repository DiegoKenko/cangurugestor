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

  Future<List<Paciente>> todosPacientesCuidador(
      String responsavelId, String cuidadorId) async {
    List<Paciente> pacientes = [];
    if (cuidadorId.isNotEmpty || responsavelId.isNotEmpty) {
      var paciValue = await firestore
          .collection('pacientes')
          .where('responsavel', isEqualTo: responsavelId)
          .get();

      for (var doc in paciValue.docs) {
        var cuidValue =
            await doc.reference.collection('cuidadores').doc(cuidadorId).get();

        if (cuidValue.exists) {
          pacientes.add(Paciente.fromMap(doc.data()));
          pacientes.last.id = doc.id;
        }
      }
    }
    return pacientes;
  }

  incluirPacienteCuidador(String idPaciente, String idCuidador) {
    if (idPaciente.isNotEmpty && idCuidador.isNotEmpty) {
      firestore
          .collection('pacientes')
          .doc(idPaciente)
          .collection('cuidadores')
          .doc(idCuidador)
          .set({'data': DateTime.now()});
      firestore
          .collection('cuidadores')
          .doc(idCuidador)
          .collection('pacientes')
          .doc(idPaciente)
          .set({'data': DateTime.now()});
    }
  }

  excluirPacienteCuidador(String idPaciete, String idCuidador) {
    if (idPaciete.isNotEmpty && idCuidador.isNotEmpty) {
      firestore
          .collection('pacientes')
          .doc(idPaciete)
          .collection('cuidadores')
          .doc(idCuidador)
          .delete();

      firestore
          .collection('cuidadores')
          .doc(idCuidador)
          .collection('pacientes')
          .doc(idPaciete)
          .delete();
    }
  }
}
