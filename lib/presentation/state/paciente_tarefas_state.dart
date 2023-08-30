import 'package:cangurugestor/const/enum/enum_tarefa.dart';
import 'package:cangurugestor/domain/entity/paciente.dart';
import 'package:cangurugestor/domain/entity/tarefa.dart';

abstract class ListaTarefaPacienteState {}

class ListaTarefasInitialState extends ListaTarefaPacienteState {
  ListaTarefasInitialState() : super();
}

class ListaTarefasReadyState extends ListaTarefaPacienteState {
  PacienteEntity paciente;

  List<TarefaEntity> tarefas;
  ListaTarefasReadyState(
    this.paciente,
    this.tarefas,
  ) : super();
}
