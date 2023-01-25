import 'package:cangurugestor/model/cuidador.dart';
import 'package:cangurugestor/model/gestor.dart';
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

    if (!responsavel.gestor.idClientes.contains(responsavel.id)) {
      await firestore.collection('gestores').doc(responsavel.gestor.id).update({
        'idClientes': FieldValue.arrayUnion([responsavel.id])
      });
    }

    return responsavel;
  }

  Future<void> atualizarResponavel(Responsavel responsavel) async {
    await firestore.collection('responsaveis').doc(responsavel.id).get().then(
      (snapshot) {
        snapshot.reference.update(responsavel.toMap());
      },
    );

    if (!responsavel.gestor.idClientes.contains(responsavel.id)) {
      await firestore.collection('gestores').doc(responsavel.gestor.id).update({
        'idClientes': FieldValue.arrayUnion([responsavel.id])
      });
    }
  }

  Future<List<Paciente>> todosPacientesResponsavel(
      Responsavel responsavel) async {
    List<Paciente> pacientesRet = [];
    await firestore.collection('responsaveis').doc(responsavel.id).get().then(
      (doc) {
        if (doc.data() != null) {
          responsavel = Responsavel.fromMap(doc.data()!);
          responsavel.id = doc.id;
        }
      },
    );
    if (responsavel.idPacientes.isEmpty) {
      return pacientesRet;
    } else {
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

  void excluirResponsavel(Gestor gestor, Responsavel responsavel) {
    //firestore.collection('responsaveis').doc(responsavel.id).delete();
    firestore.collection('gestores').doc(gestor.id).update({
      'idClientes': FieldValue.arrayRemove([responsavel.id])
    });
    firestoreLogin.deleteLogin(responsavel.id);
  }
}
