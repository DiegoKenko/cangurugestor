import 'package:cangurugestor/global.dart';
import 'package:cangurugestor/model/paciente.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PacienteGetDatasource {
  Future<Paciente> get(String idPaciente) async {
    Paciente paciente = Paciente();
    if (idPaciente.isNotEmpty) {
      await getIt<FirebaseFirestore>()
          .collection('pacientes')
          .doc(idPaciente)
          .get()
          .then((value) {
        if (value.exists) {
          return Paciente.fromMap(value.data()!);
        }
      });
    }
    throw paciente;
  }
}
