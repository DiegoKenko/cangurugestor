import 'package:cangurugestor/const/global.dart';
import 'package:cangurugestor/domain/entity/consulta.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ConsultaPacienteGetAllDatasource {
  Future<List<ConsultaEntity>> todasConsultasPaciente(String idpaciente) async {
    List<ConsultaEntity> consultas = [];
    if (idpaciente.isEmpty) {
      return consultas;
    }
    var snap = await getIt<FirebaseFirestore>()
        .collection('pacientes')
        .doc(idpaciente)
        .collection('consultas')
        .get();

    for (var doc in snap.docs) {
      var consulta = ConsultaEntity.fromMap(doc.data());
      consulta.id = doc.id;
      consultas.add(consulta);
    }
    return consultas;
  }
}
