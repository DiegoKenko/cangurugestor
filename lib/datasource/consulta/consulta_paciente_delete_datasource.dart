import 'package:cangurugestor/const/global.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ConsultaPacienteDeleteDatasource {
  Future<void> call(
    String idConsulta,
    String idPaciente,
  ) async {
    await getIt<FirebaseFirestore>()
        .collection('pacientes')
        .doc(idPaciente)
        .collection('consultas')
        .doc(idConsulta)
        .delete();
  }
}
