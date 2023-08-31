import 'package:cangurugestor/const/global.dart';
import 'package:cangurugestor/domain/entity/consulta.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ConsultaPacienteGetDatasource {
  Future<ConsultaEntity> call(
    String idConsulta,
    String idPaciente,
  ) async {
    var consulta = ConsultaEntity();
    var snapshot = await getIt<FirebaseFirestore>()
        .collection('pacientes')
        .doc(idPaciente)
        .collection('consultas')
        .doc(idConsulta)
        .get();
    if (snapshot.exists) {
      consulta = ConsultaEntity.fromMap(snapshot.data()!);
      consulta.id = snapshot.id;
    }
    return consulta;
  }
}
