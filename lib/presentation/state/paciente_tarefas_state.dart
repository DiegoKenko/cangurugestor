import 'package:cangurugestor/const/enum/enum_tarefa.dart';
import 'package:cangurugestor/domain/entity/paciente_entity.dart';
import 'package:cangurugestor/domain/entity/tarefa_entity.dart';

abstract class ListaTarefaPacienteState {}

class ListaTarefasInitialState extends ListaTarefaPacienteState {
  ListaTarefasInitialState() : super();
}

class ListaTarefasSuccessState extends ListaTarefaPacienteState {
  PacienteEntity paciente;

  List<TarefaEntity> tarefas;
  ListaTarefasSuccessState(
    this.paciente,
    this.tarefas,
  ) : super();
}
