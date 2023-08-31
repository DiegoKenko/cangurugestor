import 'package:cangurugestor/const/global.dart';
import 'package:cangurugestor/domain/entity/consulta_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ConsultaPacienteCreateDatasource {
  Future<ConsultaEntity> call(
    ConsultaEntity consulta,
    String idPaciente,
  ) async {
    if (idPaciente.isEmpty) {
      return consulta;
    }
    var con = await getIt<FirebaseFirestore>()
        .collection('pacientes')
        .doc(idPaciente)
        .collection('consultas')
        .add(consulta.toMap());
    consulta.id = con.id;
    return consulta;
  }
}
