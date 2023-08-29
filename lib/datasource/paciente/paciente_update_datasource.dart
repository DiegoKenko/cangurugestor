import 'package:cangurugestor/global.dart';
import 'package:cangurugestor/model/paciente.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PacienteUpdateDatasource {
  Future<void> update(Paciente paciente) async {
    if (paciente.id.isEmpty) {
      return;
    }
    await getIt<FirebaseFirestore>()
        .collection('pacientes')
        .doc(paciente.id)
        .update(paciente.toMap());
  }
}
