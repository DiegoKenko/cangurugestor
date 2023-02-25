import 'package:cangurugestor/model/atividade.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreAtividade {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<Atividade> atividadePaciente(
    String idAtividade,
    String idPaciente,
  ) async {
    DocumentSnapshot<Map<String, dynamic>> snap = await firestore
        .collection('pacientes')
        .doc(idPaciente)
        .collection('atividades')
        .doc(idAtividade)
        .get();
    Atividade atividade = Atividade.fromMap(snap.data()!);
    atividade.id = snap.id;
    return atividade;
  }

  Future<void> atualizarAtividadePaciente(
    Atividade atividade,
    String idPaciente,
  ) async {
    await firestore
        .collection('pacientes')
        .doc(idPaciente)
        .collection('atividades')
        .doc(atividade.id)
        .get()
        .then((value) => value.reference.update(atividade.toMap()));
  }

  Future<Atividade> novaAtividadePaciente(
    Atividade atividade,
    String idPaciente,
  ) async {
    var ativ = await firestore
        .collection('pacientes')
        .doc(idPaciente)
        .collection('atividades')
        .add(atividade.toMap());

    atividade.id = ativ.id;
    return atividade;
  }

  Future<void> excluirAtividadePaciente(
    String idAtividade,
    String idPaciente,
  ) async {
    await firestore
        .collection('pacientes')
        .doc(idPaciente)
        .collection('atividades')
        .doc(idAtividade)
        .delete();
  }

  Future<List<Atividade>> todasAtividadesPaciente(String idPaciente) async {
    List<Atividade> atvReturn = [];
    if (idPaciente.isNotEmpty) {
      QuerySnapshot<Map<String, dynamic>> snap = await firestore
          .collection('pacientes')
          .doc(idPaciente)
          .collection('atividades')
          .get();
      for (var element in snap.docs) {
        var atv = Atividade.fromMap(element.data());
        atv.id = element.id;
        atvReturn.add(atv);
      }
    }
    return atvReturn;
  }
}
