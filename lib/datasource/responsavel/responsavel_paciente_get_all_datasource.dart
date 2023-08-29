import 'package:cangurugestor/global.dart';
import 'package:cangurugestor/model/paciente.dart';
import 'package:cangurugestor/model/responsavel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart';

class ResponsavelPacienteGetAllDatasource{
   Future<List<Paciente>> todosPacientesResponsavel(
    Responsavel responsavel,
  ) async {
    var snap = await getIt<FirebaseFirestore>()
        .collection('pacientes')
        .where('idResponsavel', isEqualTo: responsavel.id)
        .get();
    return snap.docs.map((e) {
      Paciente paciente = Paciente.fromMap(e.data());
      paciente.id = e.id;
      return paciente;
    }).toList();
  }
}