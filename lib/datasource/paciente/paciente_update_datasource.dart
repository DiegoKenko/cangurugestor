import 'package:cangurugestor/const/global.dart';
import 'package:cangurugestor/domain/entity/paciente_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PacienteUpdateDatasource {
  Future<void> call(PacienteEntity paciente) async {
    if (paciente.id.isEmpty) {
      return;
    }
    await getIt<FirebaseFirestore>()
        .collection('pacientes')
        .doc(paciente.id)
        .update(paciente.toMap());
  }
}
