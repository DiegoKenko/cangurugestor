import 'package:cangurugestor/domain/entity/atividade_entity.dart';

abstract class AtividadeState {
  AtividadeState();
}

class AtividadeInitialState extends AtividadeState {
  AtividadeInitialState() : super();
}

class AtividadeLoadingState extends AtividadeState {
  AtividadeLoadingState() : super();
}

class AtividadeSuccessState extends AtividadeState {
  final AtividadeEntity atividade;
  AtividadeSuccessState(this.atividade) : super();
}
