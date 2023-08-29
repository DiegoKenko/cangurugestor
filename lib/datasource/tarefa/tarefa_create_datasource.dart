import 'package:cangurugestor/global.dart';
import 'package:cangurugestor/model/paciente.dart';
import 'package:cangurugestor/model/tarefa.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TarefaCreateDatasource {
  Future<Tarefa> insert(Paciente paciente, Tarefa tarefa) async {
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
