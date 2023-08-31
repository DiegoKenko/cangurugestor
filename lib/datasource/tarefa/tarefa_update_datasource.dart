import 'package:cangurugestor/const/global.dart';
import 'package:cangurugestor/domain/entity/paciente_entity.dart';
import 'package:cangurugestor/domain/entity/tarefa_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TarefaUpdateDatasource {
  Future<void> call(PacienteEntity paciente, TarefaEntity tarefa) async {
    if (paciente.id.isNotEmpty && tarefa.id.isNotEmpty) {
      await getIt<FirebaseFirestore>()
          .collection('pacientes')
          .doc(paciente.id)
          .collection('tarefas')
          .doc(tarefa.id)
          .update(tarefa.toMap());
    }
  }
}
