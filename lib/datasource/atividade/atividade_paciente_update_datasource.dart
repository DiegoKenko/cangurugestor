import 'package:cangurugestor/global.dart';
import 'package:cangurugestor/model/atividade.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AtividadePacienteUpdateDatasource {
  Future<void> atualizarAtividadePaciente(
    Atividade atividade,
    String idPaciente,
  ) async {
    await getIt<FirebaseFirestore>()
        .collection('pacientes')
        .doc(idPaciente)
        .collection('atividades')
        .doc(atividade.id)
        .get()
        .then((value) => value.reference.update(atividade.toMap()));
  }
}
