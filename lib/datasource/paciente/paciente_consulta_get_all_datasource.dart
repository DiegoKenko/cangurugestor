import 'package:cangurugestor/const/global.dart';
import 'package:cangurugestor/domain/entity/consulta.dart';
import 'package:cangurugestor/domain/entity/paciente.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PacienteConsultaGetAllDatasource {
  Future<List<ConsultaEntity>> call(PacienteEntity paciente) async {
    var doc = await getIt<FirebaseFirestore>()
        .collection('pacientes')
        .doc(paciente.id)
        .collection('consultas')
        .get();
    if (doc.docs.isNotEmpty) {
      return doc.docs.map((e) {
        ConsultaEntity consulta = ConsultaEntity.fromMap(e.data());
        consulta.id = e.id;
        return consulta;
      }).toList();
    } else {
      return [];
    }
  }
}
