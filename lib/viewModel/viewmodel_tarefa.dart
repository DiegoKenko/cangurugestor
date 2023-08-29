import 'package:cangurugestor/datasource/tarefa/fire_tarefa.dart';
import 'package:cangurugestor/model/paciente.dart';
import 'package:cangurugestor/model/tarefa.dart';

class TarefaViewModel {
  final Tarefa tarefa;
  final Paciente paciente;
  TarefaViewModel(this.tarefa, this.paciente);

  Future<void> update() async {
    await FirestoreTarefa().update(paciente, tarefa);
  }

  Future<void> delete() async {
    await FirestoreTarefa().delete(paciente.id, tarefa.id);
  }
}
