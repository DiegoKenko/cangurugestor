import 'package:cangurugestor/global.dart';
import 'package:cangurugestor/model/paciente.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PacienteCreateDatasource {
  Future<Paciente> create(Paciente paciente) async {
    var doc = await getIt<FirebaseFirestore>()
        .collection('pacientes')
        .add(paciente.toMap());
    paciente.id = doc.id;
    return paciente;
  }
}
