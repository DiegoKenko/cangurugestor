import 'package:cangurugestor/const/global.dart';
import 'package:cangurugestor/domain/entity/paciente_entity.dart';
import 'package:cangurugestor/domain/entity/tarefa_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TarefaPacienteUpdateDatasource {
  Future<void> atualizarTarefaPaciente(
      TarefaEntity tarefa, PacienteEntity paciente,) async {
    await getIt<FirebaseFirestore>()
        .collection('pacientes')
        .doc(paciente.id)
        .collection('tarefas')
        .doc(tarefa.id)
        .update(tarefa.toMap());
  }
}
