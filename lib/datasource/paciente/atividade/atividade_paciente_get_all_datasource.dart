import 'package:cangurugestor/const/global.dart';
import 'package:cangurugestor/domain/entity/atividade_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AtividadePacienteGetAllDatasource {
  Future<List<AtividadeEntity>> call(String idPaciente) async {
    List<AtividadeEntity> atvReturn = [];
    if (idPaciente.isNotEmpty) {
      QuerySnapshot<Map<String, dynamic>> snap =
          await getIt<FirebaseFirestore>()
              .collection('pacientes')
              .doc(idPaciente)
              .collection('atividades')
              .get();
      for (var element in snap.docs) {
        var atv = AtividadeEntity.fromMap(element.data());
        atv.id = element.id;
        atvReturn.add(atv);
      }
    }
    return atvReturn;
  }
}
