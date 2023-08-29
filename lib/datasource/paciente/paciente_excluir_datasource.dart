import 'package:cangurugestor/global.dart';
import 'package:cangurugestor/model/paciente.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PacienteExcluirDatasource {
  Future<void> excluirPaciente(
    Paciente paciente,
  ) async {
    getIt<FirebaseFirestore>()
        .collection('pacientes')
        .doc(paciente.id)
        .delete();
  }
}
