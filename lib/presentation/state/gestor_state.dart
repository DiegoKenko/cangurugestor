import 'package:cangurugestor/domain/entity/gestor.dart';

abstract class GestorState {}

class GestorInitialState extends GestorState {
  GestorInitialState() : super();
}

class GestorReadyState extends GestorState {
  GestorEntity gestor;
  GestorReadyState(this.gestor) : super();
}

class GestorLoadingState extends GestorState {
  GestorLoadingState() : super();
}
