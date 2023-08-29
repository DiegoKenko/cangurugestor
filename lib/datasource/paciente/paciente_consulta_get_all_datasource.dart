import 'package:cangurugestor/global.dart';
import 'package:cangurugestor/model/consulta.dart';
import 'package:cangurugestor/model/paciente.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PacienteConsultaGetAllDatasource{
   Future<List<Consulta>> todasConsultasPaciente(Paciente paciente) async {
    var doc = await getIt<FirebaseFirestore>()
        .collection('pacientes')
        .doc(paciente.id)
        .collection('consultas')
        .get();
    if (doc.docs.isNotEmpty) {
      return doc.docs.map((e) {
        Consulta consulta = Consulta.fromMap(e.data());
        consulta.id = e.id;
        return consulta;
      }).toList();
    } else {
      return [];
    }
  }
}