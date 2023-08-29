import 'package:cangurugestor/datasource/gestor/gestor_get_datasource.dart';
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

class GestorLoginEvent extends GestorEvent {
  Gestor gestor;
  GestorLoginEvent(this.gestor);
}

abstract class GestorState {
  Gestor gestor = Gestor();
  bool loading;

  GestorState(this.gestor, {this.loading = false});
}

class GestorInitialState extends GestorState {
  GestorInitialState() : super(Gestor());
}

class GestorReadyState extends GestorState {
  GestorReadyState({required Gestor gestor}) : super(gestor);
}

class GesttorLoadingState extends GestorState {
  GesttorLoadingState({required Gestor gestor}) : super(gestor, loading: true);
}

class GestorBloc extends Bloc<GestorEvent, GestorState> {
  GestorBloc() : super(GestorInitialState()) {
    on<GestorLoginEvent>(
      (event, emit) {
        emit(GesttorLoadingState(gestor: state.gestor));
        state.gestor = event.gestor;
        emit(GestorReadyState(gestor: state.gestor));
      },
    );

    on<GestorLoadClientesEvent>((event, emit) async {
      emit(GesttorLoadingState(gestor: state.gestor));
      state.gestor.clientes =
          await FirestoreGestor().todosClientesGestor(state.gestor);
      emit(GestorReadyState(gestor: state.gestor));
    });

    on<GestorLoadCuidadoresEvent>(
      (event, emit) async {
        emit(GesttorLoadingState(gestor: state.gestor));
        state.gestor.cuidadores =
            await FirestoreGestor().todosCuidadoresGestor(state.gestor);
        emit(GestorReadyState(gestor: state.gestor));
      },
    );
  }
}
