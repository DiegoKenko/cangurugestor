import 'package:cangurugestor/firebaseUtils/fire_cuidador.dart';
import 'package:cangurugestor/model/cuidador.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class CuidadorEvent {
  CuidadorEvent();
}

class CuidadorUpdateEvent extends CuidadorEvent {
  CuidadorUpdateEvent();
}

class CuidadorAddEvent extends CuidadorEvent {
  final String idGestor;
  CuidadorAddEvent(this.idGestor);
}

class CuidadorLoadPacientesEvent extends CuidadorEvent {
  CuidadorLoadPacientesEvent();
}

class CuidadorLoginEvent extends CuidadorEvent {
  final Cuidador cuidador;
  CuidadorLoginEvent(this.cuidador);
}

class CuidadorDeleteEvent extends CuidadorEvent {
  CuidadorDeleteEvent();
}

abstract class CuidadorState {
  Cuidador cuidador;
  CuidadorState(this.cuidador);
}

class CuidadorInitialState extends CuidadorState {
  CuidadorInitialState(Cuidador cuidador) : super(cuidador);
}

class CuidadorReadyState extends CuidadorState {
  CuidadorReadyState(Cuidador cuidador) : super(cuidador);
}

class CuidadorBloc extends Bloc<CuidadorEvent, CuidadorState> {
  CuidadorBloc(Cuidador cuidador) : super(CuidadorInitialState(cuidador)) {
    on<CuidadorLoadPacientesEvent>(
      (event, emit) async {
        state.cuidador.pacientes =
            await FirestoreCuidador().todosPacientesCuidador(state.cuidador);
        emit(CuidadorReadyState(state.cuidador));
      },
    );

    on<CuidadorLoginEvent>(
      (event, emit) async {
        emit(CuidadorReadyState(event.cuidador));
      },
    );

    on<CuidadorAddEvent>(
      (event, emit) async {
        state.cuidador.idGestor = event.idGestor;
        emit(CuidadorReadyState(state.cuidador));
      },
    );

    on<CuidadorUpdateEvent>(
      (event, emit) async {
        if (state.cuidador.id.isEmpty) {
          state.cuidador = await FirestoreCuidador().create(state.cuidador);
        } else {
          await FirestoreCuidador().update(state.cuidador);
        }
        emit(CuidadorReadyState(state.cuidador));
      },
    );

    on<CuidadorDeleteEvent>(
      (event, emit) async {
        await FirestoreCuidador().delete(state.cuidador);
        emit(CuidadorInitialState(Cuidador()));
      },
    );
  }
}
