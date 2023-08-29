import 'package:cangurugestor/global.dart';
import 'package:cangurugestor/model/paciente.dart';
import 'package:cangurugestor/model/tarefa.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TarefaCreateMultiDatasource {
  Future<void> criaMultiplasTarefas(
    Paciente paciente,
    List<Tarefa> tarefas,
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
