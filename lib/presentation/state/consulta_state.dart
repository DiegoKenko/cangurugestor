import 'package:cangurugestor/domain/entity/consulta_entity.dart';

abstract class ConsultaState {
  ConsultaState();
}

class ConsultaInitialState extends ConsultaState {
  ConsultaInitialState() : super();
}

class ConsultaLoadingState extends ConsultaState {
  ConsultaLoadingState() : super();
}

class ConsultaErrorState extends ConsultaState {
  final String message;
  ConsultaErrorState(this.message) : super();
}

class ConsultaSuccessState extends ConsultaState {
  final ConsultaEntity consulta;
  ConsultaSuccessState(this.consulta) : super();
}
