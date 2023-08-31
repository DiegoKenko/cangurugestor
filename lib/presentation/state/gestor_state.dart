import 'package:cangurugestor/domain/entity/gestor_entity.dart';

abstract class GestorState {}

class GestorInitialState extends GestorState {
  GestorInitialState() : super();
}

class GestorSuccessState extends GestorState {
  GestorEntity gestor;
  GestorSuccessState(this.gestor) : super();
}

class GestorLoadingState extends GestorState {
  GestorLoadingState() : super();
}
