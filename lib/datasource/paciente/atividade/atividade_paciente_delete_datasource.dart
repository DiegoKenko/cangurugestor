import 'package:cangurugestor/const/global.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AtividadePacienteDeleteDatasource {
  Future<void> call(
    String idAtividade,
    String idPaciente,
  ) async {
    await getIt<FirebaseFirestore>()
        .collection('pacientes')
        .doc(idPaciente)
        .collection('atividades')
        .doc(idAtividade)
        .delete();
  }
}
