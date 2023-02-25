import 'package:cangurugestor/firebaseUtils/fire_consulta.dart';
import 'package:cangurugestor/model/consulta.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class ConsultaState {
  Consulta consulta;
  ConsultaState(this.consulta);
}

class ConsultaInitialState extends ConsultaState {
  ConsultaInitialState(Consulta consulta) : super(consulta);
}

abstract class ConsultaEvent {}

class ConsultaLoadEvent extends ConsultaEvent {
  ConsultaLoadEvent();
}

class ConsultaDeleteEvent extends ConsultaEvent {
  ConsultaDeleteEvent();
}

class ConsultaUpdateEvent extends ConsultaEvent {
  ConsultaUpdateEvent();
}

class ConsultaBloc extends Bloc<ConsultaEvent, ConsultaState> {
  ConsultaBloc(Consulta consulta) : super(ConsultaInitialState(consulta)) {
    on<ConsultaLoadEvent>(
      (event, emit) {
        consulta = consulta;
        emit(ConsultaInitialState(consulta));
      },
    );

    on<ConsultaDeleteEvent>(
      (event, emit) async {
        await FirestoreConsulta().excluirConsultaPaciente(
          consulta.id,
          consulta.paciente.id,
        );
        emit(ConsultaInitialState(consulta));
      },
    );

    on<ConsultaUpdateEvent>(
      (event, emit) async {
        if (consulta.id.isNotEmpty) {
          FirestoreConsulta()
              .atualizarConsultaPaciente(consulta, consulta.paciente.id);
        } else {
          Consulta consulta = await FirestoreConsulta()
              .novaConsultaPaciente(state.consulta, state.consulta.paciente.id);
          consulta = consulta;
        }
        consulta = consulta;
        emit(ConsultaInitialState(consulta));
      },
    );
  }
}
