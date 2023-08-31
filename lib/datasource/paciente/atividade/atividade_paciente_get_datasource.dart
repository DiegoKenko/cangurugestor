import 'package:cangurugestor/const/global.dart';
import 'package:cangurugestor/domain/entity/atividade_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AtividadePacienteGetDatasource {
  Future<AtividadeEntity> call(String idAtividade, String idPaciente) async {
    DocumentSnapshot<Map<String, dynamic>> snap =
        await getIt<FirebaseFirestore>()
            .collection('pacientes')
            .doc(idPaciente)
            .collection('atividades')
            .doc(idAtividade)
            .get();
    AtividadeEntity atividade = AtividadeEntity.fromMap(snap.data()!);
    atividade.id = snap.id;
    return atividade;
  }
}
