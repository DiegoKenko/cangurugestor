import 'package:cangurugestor/global.dart';
import 'package:cangurugestor/model/atividade.dart';
import 'package:cangurugestor/model/paciente.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PacienteAtividageGetAllDatasource {
  Future<List<Atividade>> todasAtividadesPaciente(Paciente paciente) async {
    var doc = await getIt<FirebaseFirestore>()
        .collection('pacientes')
        .doc(paciente.id)
        .collection('atividades')
        .get();
    if (doc.docs.isNotEmpty) {
      return doc.docs.map((e) {
        Atividade atividade = Atividade.fromMap(e.data());
        atividade.id = e.id;
        return atividade;
      }).toList();
    } else {
      return [];
    }
  }
}
