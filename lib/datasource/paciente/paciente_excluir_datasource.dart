import 'package:cangurugestor/const/global.dart';
import 'package:cangurugestor/domain/entity/paciente.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PacienteExcluirDatasource {
  Future<void> call(
    PacienteEntity paciente,
  ) async {
    getIt<FirebaseFirestore>()
        .collection('pacientes')
        .doc(paciente.id)
        .delete();
  }
}
