import 'package:cangurugestor/domain/entity/responsavel_entity.dart';

abstract class ResponsavelState {}

class ResponsavelInitialState extends ResponsavelState {
  ResponsavelInitialState() : super();
}

class ResponsavelSuccessState extends ResponsavelState {
  ResponsavelEntity responsavel;
  ResponsavelSuccessState(this.responsavel) : super();
}

class ResponsavelLoadingState extends ResponsavelState {
  ResponsavelLoadingState() : super();
}

class ResponsavelEmptyState extends ResponsavelState {
  ResponsavelEmptyState() : super();
}
