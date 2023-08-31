import 'package:cangurugestor/domain/entity/paciente_entity.dart';

abstract class PacienteEvent {
  PacienteEvent();
}

abstract class PacienteState {}

class PacienteInitialState extends PacienteState {
  PacienteInitialState() : super();
}

class PacienteSuccessState extends PacienteState {
  final PacienteEntity paciente;
  PacienteSuccessState(this.paciente) : super();
}

class PacienteLoadingState extends PacienteState {
  PacienteLoadingState() : super();
}
