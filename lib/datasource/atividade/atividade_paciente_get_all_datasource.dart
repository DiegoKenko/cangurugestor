import 'package:cangurugestor/global.dart';
import 'package:cangurugestor/model/atividade.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AtividadePacienteGetAllDatasource {
  Future<List<Atividade>> call(String idPaciente) async {
    List<Atividade> atvReturn = [];
    if (idPaciente.isNotEmpty) {
      QuerySnapshot<Map<String, dynamic>> snap =
          await getIt<FirebaseFirestore>()
              .collection('pacientes')
              .doc(idPaciente)
              .collection('atividades')
              .get();
      for (var element in snap.docs) {
        var atv = Atividade.fromMap(element.data());
        atv.id = element.id;
        atvReturn.add(atv);
      }
    }
    return atvReturn;
  }
}
