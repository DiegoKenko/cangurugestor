import 'package:cangurugestor/const/global.dart';
import 'package:cangurugestor/domain/entity/paciente.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PacienteGetDatasource {
  Future<PacienteEntity> call(String idPaciente) async {
    PacienteEntity paciente = PacienteEntity();
    if (idPaciente.isNotEmpty) {
      await getIt<FirebaseFirestore>()
          .collection('pacientes')
          .doc(idPaciente)
          .get()
          .then((value) {
        if (value.exists) {
          return PacienteEntity.fromMap(value.data()!);
        }
      });
    }
    throw paciente;
  }
}
