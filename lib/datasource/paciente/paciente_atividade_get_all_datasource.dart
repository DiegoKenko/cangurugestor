import 'package:cangurugestor/const/global.dart';
import 'package:cangurugestor/domain/entity/atividade.dart';
import 'package:cangurugestor/domain/entity/paciente.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PacienteAtividadeGetAllDatasource {
  Future<List<AtividadeEntity>> call(PacienteEntity paciente) async {
    var doc = await getIt<FirebaseFirestore>()
        .collection('pacientes')
        .doc(paciente.id)
        .collection('atividades')
        .get();
    if (doc.docs.isNotEmpty) {
      return doc.docs.map((e) {
        AtividadeEntity atividade = AtividadeEntity.fromMap(e.data());
        atividade.id = e.id;
        return atividade;
      }).toList();
    } else {
      return [];
    }
  }
}
