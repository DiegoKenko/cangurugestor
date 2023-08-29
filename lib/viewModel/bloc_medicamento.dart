import 'package:cangurugestor/datasource/medicamento/fire_medicamento.dart';
import 'package:cangurugestor/model/medicamento.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class MedicamentoState {
  Medicamento medicamento;
  MedicamentoState(this.medicamento);
}

class MedicamentoInitialState extends MedicamentoState {
  MedicamentoInitialState(Medicamento medicamento) : super(medicamento);
}

abstract class MedicamentoEvent {}

class MedicamentoLoadEvent extends MedicamentoEvent {
  MedicamentoLoadEvent();
}

class MedicamentoDeleteEvent extends MedicamentoEvent {
  MedicamentoDeleteEvent();
}

class MedicamentoUpdateEvent extends MedicamentoEvent {
  MedicamentoUpdateEvent();
}

class MedicamentoBloc extends Bloc<MedicamentoEvent, MedicamentoState> {
  MedicamentoBloc(Medicamento medicamento)
      : super(MedicamentoInitialState(medicamento)) {
    on<MedicamentoLoadEvent>(
      (event, emit) {
        medicamento = medicamento;
        emit(MedicamentoInitialState(medicamento));
      },
    );

    on<MedicamentoDeleteEvent>(
      (event, emit) async {
        await FirestoreMedicamento().excluirMedicamentoPaciente(
          medicamento.id,
          medicamento.paciente.id,
        );
        emit(MedicamentoInitialState(medicamento));
      },
    );

    on<MedicamentoUpdateEvent>(
      (event, emit) async {
        if (medicamento.id.isNotEmpty) {
          FirestoreMedicamento().atualizarMedicamentoPaciente(
            medicamento,
            medicamento.paciente.id,
          );
        } else {
          Medicamento medicamento =
              await FirestoreMedicamento().novoMedicamentoPaciente(
            state.medicamento,
            state.medicamento.paciente.id,
          );
          medicamento = medicamento;
        }
        medicamento = medicamento;
        emit(MedicamentoInitialState(medicamento));
      },
    );
  }
}
