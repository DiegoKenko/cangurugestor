import 'package:cangurugestor/firebaseUtils/fire_gestor.dart';
import 'package:cangurugestor/firebaseUtils/fire_responsavel.dart';
import 'package:cangurugestor/model/gestor.dart';
import 'package:cangurugestor/model/paciente.dart';
import 'package:cangurugestor/model/responsavel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class ResponsavelEvent {
  ResponsavelEvent();
}

class ResponsavelUpdateEvent extends ResponsavelEvent {
  ResponsavelUpdateEvent();
}

class ResponsavelLoginEvent extends ResponsavelEvent {
  Responsavel responsavel;
  ResponsavelLoginEvent(this.responsavel);
}

class ResponsavelLoadPacientesEvent extends ResponsavelEvent {
  ResponsavelLoadPacientesEvent();
}

abstract class ResponsavelState {
  Responsavel responsavel;
  ResponsavelState(this.responsavel);
}

class ResponsavelInitialState extends ResponsavelState {
  ResponsavelInitialState(Responsavel responsavel) : super(responsavel);
}

class ResponsavelReadyState extends ResponsavelState {
  ResponsavelReadyState(Responsavel responsavel) : super(responsavel);
}

class ResponsavelBloc extends Bloc<ResponsavelEvent, ResponsavelState> {
  ResponsavelBloc(Responsavel responsavel)
      : super(ResponsavelInitialState(responsavel)) {
    on<ResponsavelLoadPacientesEvent>(
      (event, emit) async {
        state.responsavel.pacientes = await FirestoreResponsavel()
            .todosPacientesResponsavel(state.responsavel);
        emit(ResponsavelReadyState(state.responsavel));
      },
    );

    on<ResponsavelUpdateEvent>(
      (event, emit) async {
        if (state.responsavel.id.isEmpty) {
          state.responsavel =
              await FirestoreResponsavel().create(state.responsavel);
        } else {
          await FirestoreResponsavel().update(state.responsavel);
        }
        emit(ResponsavelReadyState(state.responsavel));
      },
    );

    on<ResponsavelLoginEvent>(
      (event, emit) async {
        emit(ResponsavelReadyState(event.responsavel));
      },
    );
  }
}
