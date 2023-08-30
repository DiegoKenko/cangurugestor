import 'package:cangurugestor/const/global.dart';
import 'package:cangurugestor/domain/entity/paciente.dart';
import 'package:cangurugestor/domain/entity/tarefa.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TarefaCreateDatasource {
  Future<TarefaEntity> call(
      PacienteEntity paciente, TarefaEntity tarefa) async {
    if (paciente.id.isNotEmpty) {
      var doc = await getIt<FirebaseFirestore>()
          .collection('pacientes')
          .doc(paciente.id)
          .collection('tarefas')
          .add(tarefa.toMap());
      tarefa.id = doc.id;
    }
    return tarefa;
  }
}
