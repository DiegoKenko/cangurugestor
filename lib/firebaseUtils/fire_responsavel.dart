import 'package:cangurugestor/classes/cuidador.dart';
import 'package:cangurugestor/classes/login.dart';
import 'package:cangurugestor/classes/paciente.dart';
import 'package:cangurugestor/classes/responsavel.dart';
import 'package:cangurugestor/firebaseUtils/fire_login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreResponsavel {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirestoreLogin firestoreLogin = FirestoreLogin();
  Future<Responsavel> incluirResponsavel(Responsavel responsavel) async {
    var doc =
        await firestore.collection('responsaveis').add(responsavel.toMap());
    responsavel.id = doc.id;
    firestoreLogin.atualizaLogin(Login(
        colecao: 'responsaveis',
        cpf: responsavel.cpf,
        doc: doc.id,
        funcao: 'responsaveis',
        senha: responsavel.senha,
        ativo: responsavel.ativo));
    return responsavel;
  }

  atualizarResponavel(Responsavel responsavel) {
    firestore.collection('responsaveis').doc(responsavel.id).get().then(
      (snapshot) {
        snapshot.reference.update(responsavel.toMap());
        // Update or create its login too
        firestoreLogin.atualizaLogin(Login(
            colecao: 'responsaveis',
            cpf: responsavel.cpf,
            doc: snapshot.reference.id,
            funcao: 'responsavel',
            senha: responsavel.senha,
            ativo: responsavel.ativo));
      },
    );
  }

  Future<List<Paciente>> todosPacientesResponsavel(String idResponsavel) async {
    List<Paciente> pacientes = [];
    if (idResponsavel.isNotEmpty) {
      await firestore
          .collection('pacientes')
          .where('responsavel', isEqualTo: idResponsavel)
          .get()
          .then((value) {
        for (var doc in value.docs) {
          pacientes.add(Paciente.fromMap(doc.data()));
          pacientes.last.id = doc.id;
        }
      });
    }
    return pacientes;
  }

  Future<List<Cuidador>> todosCuidadoresResponsavel(
      String idResponsavel) async {
    List<Cuidador> cuidadores = [];
    if (idResponsavel.isNotEmpty) {
      await firestore
          .collection('cuidadores')
          .where('responsavel', isEqualTo: idResponsavel)
          .get()
          .then((value) {
        for (var doc in value.docs) {
          cuidadores.add(Cuidador.fromMap(doc.data()));
          cuidadores.last.id = doc.id;
        }
      });
    }
    return cuidadores;
  }

  excluirResponsavel(String idReponsavel) {
    firestore.collection('responsaveis').doc(idReponsavel).delete();

    firestoreLogin.deleteLogin(idReponsavel);
  }
}
