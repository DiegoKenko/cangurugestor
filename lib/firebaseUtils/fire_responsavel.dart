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

  void atualizarResponavel(Responsavel responsavel) {
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

  Stream<List<Paciente>> todosPacientesResponsavelStream(String idResponsavel) {
    return firestore
        .collection('pacientes')
        .where('responsavel', isEqualTo: idResponsavel)
        .snapshots()
        .map(
          (event) => event.docs.map((e) {
            var paciente = Paciente.fromMap(e.data());
            paciente.id = e.id;
            return paciente;
          }).toList(),
        );
  }

  Stream<List<Cuidador>> todosCuidadoresResponsavel(String idResponsavel) {
    return firestore
        .collection('cuidadores')
        .where('responsavel', isEqualTo: idResponsavel)
        .snapshots()
        .map(
          (event) => event.docs.map((e) {
            var cuidador = Cuidador.fromMap(e.data());
            cuidador.id = e.id;
            return cuidador;
          }).toList(),
        );
  }

  void excluirResponsavel(String idReponsavel) {
    firestore.collection('responsaveis').doc(idReponsavel).delete();

    firestoreLogin.deleteLogin(idReponsavel);
  }
}
