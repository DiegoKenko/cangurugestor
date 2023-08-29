import 'package:cangurugestor/global.dart';
import 'package:cangurugestor/model/paciente.dart';
import 'package:cangurugestor/model/tarefa.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TarefaPacienteUpdateDatasource {
  Future<void> atualizarTarefaPaciente(Tarefa tarefa, Paciente paciente) async {
    await getIt<FirebaseFirestore>()
        .collection('pacientes')
        .doc(paciente.id)
        .collection('tarefas')
        .doc(tarefa.id)
        .update(tarefa.toMap());
  }
}
