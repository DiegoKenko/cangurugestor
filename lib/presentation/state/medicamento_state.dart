import 'package:cangurugestor/domain/entity/medicamento_entity.dart';

abstract class MedicamentoState {}

class MedicamentoInitialState extends MedicamentoState {
  MedicamentoInitialState() : super();
}

class MedicamentoLoadingState extends MedicamentoState {
  MedicamentoLoadingState() : super();
}

class MedicamentoErrorState extends MedicamentoState {
  final String message;
  MedicamentoErrorState(this.message) : super();
}

class MedicamentoSuccessState extends MedicamentoState {
  final MedicamentoEntity medicamento;
  MedicamentoSuccessState(this.medicamento) : super();
}
