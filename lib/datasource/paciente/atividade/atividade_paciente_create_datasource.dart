import 'package:cangurugestor/const/global.dart';
import 'package:cangurugestor/domain/entity/atividade_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AtividadePacienteCreateDatasource {
  Future<AtividadeEntity> call(
    AtividadeEntity atividade,
    String idPaciente,
  ) async {
    var ativ = await getIt<FirebaseFirestore>()
        .collection('pacientes')
        .doc(idPaciente)
        .collection('atividades')
        .add(atividade.toMap());

    atividade.id = ativ.id;
    return atividade;
  }
}
