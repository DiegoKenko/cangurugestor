import 'package:cangurugestor/const/global.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TarefaDeleteDatasource {
  Future<void> call(String idPaciente, String idTarefa) async {
    if (idTarefa.isNotEmpty && idPaciente.isNotEmpty) {
      await getIt<FirebaseFirestore>()
          .collection('pacientes')
          .doc(idPaciente)
          .collection('tarefas')
          .doc(idTarefa)
          .delete();
    }
  }
}
