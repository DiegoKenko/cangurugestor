import 'package:cangurugestor/firebaseUtils/fire_gestor.dart';
import 'package:cangurugestor/firebaseUtils/fire_responsavel.dart';
import 'package:cangurugestor/model/gestor.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class GestorEvent {
  GestorEvent();
}

class GestorLoadClientesEvent extends GestorEvent {
  GestorLoadClientesEvent();
}

class GestorLoadCuidadoresEvent extends GestorEvent {
  GestorLoadCuidadoresEvent();
}

class GestorLoadCuidadoresDisponiveisEvent extends GestorEvent {
  GestorLoadCuidadoresDisponiveisEvent();
}

class GestorLoginEvent extends GestorEvent {
  Gestor gestor;
  GestorLoginEvent(this.gestor);
}

abstract class GestorState {
  Gestor gestor = Gestor();

  GestorState({
    required this.gestor,
  });
}

class GestorInitialState extends GestorState {
  GestorInitialState() : super(gestor: Gestor());
}

class GestorReadyState extends GestorState {
  GestorReadyState({required Gestor gestor}) : super(gestor: gestor);
}

class GestorBloc extends Bloc<GestorEvent, GestorState> {
  GestorBloc() : super(GestorInitialState()) {
    on<GestorLoginEvent>(
      (event, emit) {
        state.gestor = event.gestor;
        emit(GestorReadyState(gestor: state.gestor));
      },
    );

    on<GestorLoadClientesEvent>((event, emit) async {
      state.gestor.clientes =
          await FirestoreGestor().todosClientesGestor(state.gestor);
      emit(GestorReadyState(gestor: state.gestor));
    });

    on<GestorLoadCuidadoresEvent>(
      (event, emit) async {
        state.gestor.cuidadores =
            await FirestoreGestor().todosCuidadoresGestor(state.gestor);
        emit(GestorReadyState(gestor: state.gestor));
      },
    );

    on<GestorLoadCuidadoresDisponiveisEvent>(
      (event, emit) async {
        state.gestor.cuidadoresDisponiveis =
            await FirestoreGestor().todosCuidadoresGestor(state.gestor);
        emit(GestorReadyState(gestor: state.gestor));
      },
    );
  }
}
