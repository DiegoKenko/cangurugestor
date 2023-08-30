abstract class PacienteEvent {
  PacienteEvent();
}

abstract class PacienteState {}

class PacienteInitialState extends PacienteState {
  PacienteInitialState() : super();
}

class PacienteReadyState extends PacienteState {
  PacienteReadyState() : super();
}

class PacienteLoadedState extends PacienteState {
  PacienteLoadedState() : super();
}

class PacienteLoadingState extends PacienteState {
  PacienteLoadingState() : super();
}
