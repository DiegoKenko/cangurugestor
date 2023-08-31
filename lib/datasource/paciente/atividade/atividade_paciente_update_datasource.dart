import 'package:cangurugestor/const/global.dart';
import 'package:cangurugestor/domain/entity/atividade_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AtividadePacienteUpdateDatasource {
  Future<void> call(
    AtividadeEntity atividade,
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
