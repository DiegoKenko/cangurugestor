import 'package:cangurugestor/global.dart';
import 'package:cangurugestor/model/paciente.dart';
import 'package:cangurugestor/model/tarefa.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TarefaUpdateDatasource {
  Future<void> update(Paciente paciente, Tarefa tarefa) async {
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
