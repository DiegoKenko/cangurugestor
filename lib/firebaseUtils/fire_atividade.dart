import 'package:cangurugestor/model/atividade.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreAtividade {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  atualizarAtividadePaciente(Atividade atividade, String idPaciente) {
    firestore
        .collection('pacientes')
        .doc(idPaciente)
        .collection('atividades')
        .doc(atividade.id)
        .get()
        .then((value) => value.reference.update(atividade.toMap()));
  }

  Future<Atividade> novaAtividadePaciente(
      Atividade atividade, String idPaciente) async {
    var ativ = await firestore
        .collection('pacientes')
        .doc(idPaciente)
        .collection('atividades')
        .add(atividade.toMap());

    atividade.id = ativ.id;
    return atividade;
  }

  excluirAtividadePaciente(String idAtividade, String idPaciente) {
    firestore
        .collection('pacientes')
        .doc(idPaciente)
        .collection('atividades')
        .doc(idAtividade)
        .delete();
  }

  Future<List<String>> todasAtividades() async {
    List<String> atvReturn = [];
    firestore.collection('atividades').get().then(
      (QuerySnapshot<Map<String, dynamic>> value) {
        for (var element in value.docs) {
          if (element.data()['nome'] != null) {
            atvReturn.add(element.data()['nome']);
          }
        }
        atvReturn.sort((a, b) => a.compareTo(b));
        return atvReturn;
      },
    );
    return atvReturn;
  }
}
