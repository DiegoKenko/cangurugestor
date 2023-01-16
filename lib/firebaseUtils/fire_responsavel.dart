import 'package:cangurugestor/model/cuidador.dart';
import 'package:cangurugestor/model/login_user.dart';
import 'package:cangurugestor/model/paciente.dart';
import 'package:cangurugestor/model/responsavel.dart';
import 'package:cangurugestor/firebaseUtils/fire_login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreResponsavel {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirestoreLogin firestoreLogin = FirestoreLogin();

  Future<Responsavel> incluirResponsavel(Responsavel responsavel) async {
    var doc =
        await firestore.collection('responsaveis').add(responsavel.toMap());
    responsavel.id = doc.id;
    firestoreLogin.atualizaLogin(LoginUser(
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
        firestoreLogin.atualizaLogin(LoginUser(
            colecao: 'responsaveis',
            cpf: responsavel.cpf,
            doc: snapshot.reference.id,
            funcao: 'responsavel',
            senha: responsavel.senha,
            ativo: responsavel.ativo));
      },
    );
  }

  Future<List<Paciente>> todosPacientesResponsavel(
      Responsavel responsavel) async {
    List<Paciente> pacientesRet = [];
    DocumentSnapshot<Map<String, dynamic>> doc =
        await firestore.collection('responsaveis').doc(responsavel.id).get();

    responsavel = Responsavel.fromMap(doc.data()!);

    for (var element in responsavel.idPacientes) {
      DocumentSnapshot<Map<String, dynamic>> docPaciente =
          await firestore.collection('pacientes').doc(element).get();
      Paciente paciente = Paciente.fromMap(docPaciente.data()!);
      paciente.id = docPaciente.id;
      pacientesRet.add(paciente);
    }

    return pacientesRet;
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
