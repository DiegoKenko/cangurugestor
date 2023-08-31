import 'package:cangurugestor/const/global.dart';
import 'package:cangurugestor/domain/entity/paciente_entity.dart';
import 'package:cangurugestor/domain/entity/responsavel_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ResponsavelPacienteGetAllDatasource {
  Future<List<PacienteEntity>> call(
    ResponsavelEntity responsavel,
  ) async {
    var snap = await getIt<FirebaseFirestore>()
        .collection('pacientes')
        .where('idResponsavel', isEqualTo: responsavel.id)
        .get();
    return snap.docs.map((e) {
      PacienteEntity paciente = PacienteEntity.fromMap(e.data());
      paciente.id = e.id;
      return paciente;
    }).toList();
  }
}
