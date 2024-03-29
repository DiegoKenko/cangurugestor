import 'package:cangurugestor/firebaseUtils/fire_paciente.dart';
import 'package:cangurugestor/model/cuidador.dart';
import 'package:cangurugestor/model/paciente.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class PacienteEvent {
  PacienteEvent();
}

class PacienteLoadEvent extends PacienteEvent {
  String idPaciente;
  PacienteLoadEvent(this.idPaciente);
}

class PacienteUpdateEvent extends PacienteEvent {
  PacienteUpdateEvent();
}

class PacienteLoadCuidadoresEvent extends PacienteEvent {
  PacienteLoadCuidadoresEvent();
}

class PacienteLoadMedicamentosEvent extends PacienteEvent {
  PacienteLoadMedicamentosEvent();
}

class PacienteLoadAtividadesEvent extends PacienteEvent {
  PacienteLoadAtividadesEvent();
}

class PacienteLoadConsultasEvent extends PacienteEvent {
  PacienteLoadConsultasEvent();
}

class PacienteDeleteEvent extends PacienteEvent {
  PacienteDeleteEvent();
}

class PacienteRemoveCuidadorEvent extends PacienteEvent {
  Cuidador cuidador;
  PacienteRemoveCuidadorEvent(this.cuidador);
}

class PacienteAddCuidadorEvent extends PacienteEvent {
  Cuidador cuidador;
  PacienteAddCuidadorEvent(this.cuidador);
}

abstract class PacienteState {
  Paciente paciente;
  bool loading;
  PacienteState(this.paciente, {this.loading = false});
}

class PacienteInitialState extends PacienteState {
  PacienteInitialState(Paciente paciente) : super(paciente);
}

class PacienteReadyState extends PacienteState {
  PacienteReadyState(Paciente paciente) : super(paciente);
}

class PacienteLoadedState extends PacienteState {
  PacienteLoadedState(Paciente paciente) : super(paciente);
}

class PacienteLoadingState extends PacienteState {
  PacienteLoadingState(Paciente paciente) : super(paciente, loading: true);
}

class PacienteBloc extends Bloc<PacienteEvent, PacienteState> {
  PacienteBloc(Paciente paciente) : super(PacienteInitialState(paciente)) {
    on<PacienteLoadEvent>(
      (event, emit) async {
        emit(PacienteLoadingState(state.paciente));
        Paciente paciente = await FirestorePaciente().get(event.idPaciente);
        emit(PacienteLoadedState(paciente));
      },
    );

    on<PacienteLoadCuidadoresEvent>(
      (event, emit) async {
        emit(PacienteLoadingState(state.paciente));
        List<Cuidador> cuidadores =
            await FirestorePaciente().todosCuidadoresPaciente(state.paciente);
        state.paciente.cuidadores = cuidadores;
        emit(PacienteLoadedState(state.paciente));
      },
    );

    on<PacienteLoadMedicamentosEvent>(
      (event, emit) async {
        emit(PacienteLoadingState(state.paciente));
        state.paciente.medicamentos =
            await FirestorePaciente().todosMedicamentosPaciente(state.paciente);
        emit(PacienteLoadedState(state.paciente));
      },
    );

    on<PacienteLoadAtividadesEvent>(
      (event, emit) async {
        emit(PacienteLoadingState(state.paciente));
        state.paciente.atividades =
            await FirestorePaciente().todasAtividadesPaciente(state.paciente);
        emit(PacienteLoadedState(state.paciente));
      },
    );

    on<PacienteLoadConsultasEvent>(
      (event, emit) async {
        emit(PacienteLoadingState(state.paciente));
        state.paciente.consultas =
            await FirestorePaciente().todasConsultasPaciente(state.paciente);
        emit(PacienteLoadedState(state.paciente));
      },
    );

    on<PacienteUpdateEvent>(
      (event, emit) async {
        emit(PacienteLoadingState(state.paciente));
        if (state.paciente.nome.isNotEmpty) {
          if (state.paciente.id.isEmpty) {
            state.paciente = await FirestorePaciente().create(state.paciente);
          } else {
            await FirestorePaciente().update(state.paciente);
          }
          emit(PacienteReadyState(state.paciente));
        }
      },
    );

    on<PacienteDeleteEvent>(
      (event, emit) async {
        await FirestorePaciente().excluirPaciente(state.paciente);
        emit(PacienteReadyState(Paciente()));
      },
    );

    on<PacienteRemoveCuidadorEvent>(
      (event, emit) async {
        emit(PacienteLoadingState(state.paciente));
        if (state.paciente.idCuidadores.contains(event.cuidador.id)) {
          state.paciente.idCuidadores.remove(event.cuidador.id);
          await FirestorePaciente().update(state.paciente);
          emit(PacienteReadyState(state.paciente));
        }
      },
    );

    on<PacienteAddCuidadorEvent>(
      (event, emit) async {
        if (!state.paciente.idCuidadores.contains(event.cuidador.id)) {
          state.paciente.idCuidadores.add(event.cuidador.id);
          await FirestorePaciente().update(state.paciente);
          emit(PacienteReadyState(state.paciente));
        }
      },
    );
  }
}
