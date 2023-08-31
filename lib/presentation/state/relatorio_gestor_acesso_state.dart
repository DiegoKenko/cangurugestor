import 'package:cangurugestor/domain/entity/cuidador_entity.dart';

abstract class RelatorioGestorAcessoState {}

class InitialRelatorioGestorAcessoState extends RelatorioGestorAcessoState {}

class LoadingRelatorioGestorAcessoState extends RelatorioGestorAcessoState {}

class SuccessRelatorioGestorAcessoState extends RelatorioGestorAcessoState {
  final List<CuidadorEntity> cuidadores;
  SuccessRelatorioGestorAcessoState({required this.cuidadores});
}

class ErrorRelatorioGestorAcessoState extends RelatorioGestorAcessoState {}
