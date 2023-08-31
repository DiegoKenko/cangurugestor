import 'package:cangurugestor/domain/entity/cuidador_entity.dart';

abstract class CuidadorState {
  CuidadorState();
}

class CuidadorInitialState extends CuidadorState {
  CuidadorInitialState() : super();
}

class CuidadorSuccessState extends CuidadorState {
  CuidadorEntity cuidador;
  CuidadorSuccessState(this.cuidador) : super();
}

class CuidadorLoadingState extends CuidadorState {
  CuidadorLoadingState() : super();
}
