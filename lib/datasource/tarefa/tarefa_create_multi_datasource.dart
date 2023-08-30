import 'package:cangurugestor/const/global.dart';
import 'package:cangurugestor/domain/entity/paciente.dart';
import 'package:cangurugestor/domain/entity/tarefa.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TarefaCreateMultiDatasource {
  Future<void> criaMultiplasTarefas(
    PacienteEntity paciente,
    List<TarefaEntity> tarefas,
  ) async {
    for (var tarefa in tarefas) {
      await getIt<FirebaseFirestore>()
          .collection('pacientes')
          .doc(paciente.id)
          .collection('tarefas')
          .add(tarefa.toMap());
    }
  }
}
