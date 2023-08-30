import 'package:cangurugestor/const/global.dart';
import 'package:cangurugestor/domain/entity/paciente.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PacienteCreateDatasource {
  Future<PacienteEntity> call(PacienteEntity paciente) async {
    var doc = await getIt<FirebaseFirestore>()
        .collection('pacientes')
        .add(paciente.toMap());
    paciente.id = doc.id;
    return paciente;
  }
}
