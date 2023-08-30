import 'package:cangurugestor/domain/entity/cuidador.dart';

abstract class CuidadorState {
  CuidadorState();
}

class CuidadorInitialState extends CuidadorState {
  CuidadorInitialState() : super();
}

class CuidadorReadyState extends CuidadorState {
  CuidadorEntity cuidador;
  CuidadorReadyState(this.cuidador) : super();
}

class CuidadorLoadingState extends CuidadorState {
  CuidadorLoadingState() : super();
}
