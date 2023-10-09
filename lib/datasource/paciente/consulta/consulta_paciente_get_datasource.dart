import 'package:cangurugestor/const/global.dart';
import 'package:cangurugestor/domain/entity/consulta_entity.dart';
import 'package:cangurugestor/domain/entity/default_error_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:result_dart/result_dart.dart';

class ConsultaPacienteGetDatasource {
  Future<Result<ConsultaEntity, DefaultErrorEntity>> call(
    String idConsulta,
    String idPaciente,
  ) async {
    try {
      var snapshot = await getIt<FirebaseFirestore>()
          .collection('pacientes')
          .doc(idPaciente)
          .collection('consultas')
          .doc(idConsulta)
          .get();
      if (snapshot.exists) {
        ConsultaEntity consulta = ConsultaEntity.fromMap(snapshot.data()!);
        consulta.id = snapshot.id;
        return consulta.toSuccess();
      }
      return Failure(DefaultErrorEntity('Consulta não encontrada'));
    } catch (e) {
      return Failure(DefaultErrorEntity('Consulta não encontrada'));
    }
  }
}
