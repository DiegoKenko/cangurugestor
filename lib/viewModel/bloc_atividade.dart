import 'package:cangurugestor/firebaseUtils/fire_atividade.dart';
import 'package:cangurugestor/model/atividade.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class AtividadeState {
  Atividade atividade;
  AtividadeState(this.atividade);
}

class AtividadeInitialState extends AtividadeState {
  AtividadeInitialState(Atividade atividade) : super(atividade);
}

abstract class AtividadeEvent {}

class AtividadeLoadEvent extends AtividadeEvent {
  AtividadeLoadEvent();
}

class AtividadeDeleteEvent extends AtividadeEvent {
  AtividadeDeleteEvent();
}

class AtividadeUpdateEvent extends AtividadeEvent {
  AtividadeUpdateEvent();
}

class AtividadeBloc extends Bloc<AtividadeEvent, AtividadeState> {
  AtividadeBloc(Atividade atividade) : super(AtividadeInitialState(atividade)) {
    on<AtividadeLoadEvent>(
      (event, emit) {
        atividade = atividade;
        emit(AtividadeInitialState(atividade));
      },
    );

    on<AtividadeDeleteEvent>(
      (event, emit) {
        atividade = atividade;
        emit(AtividadeInitialState(atividade));
      },
    );

    on<AtividadeUpdateEvent>(
      (event, emit) async {
        if (atividade.id.isNotEmpty) {
          FirestoreAtividade()
              .atualizarAtividadePaciente(atividade, atividade.paciente.id);
        } else {
          Atividade atividade =
              await FirestoreAtividade().novaAtividadePaciente(
            state.atividade,
            state.atividade.paciente.id,
          );
          atividade = atividade;
        }
        atividade = atividade;
        emit(AtividadeInitialState(atividade));
      },
    );
  }
}
