import 'package:cangurugestor/datasource/gestor/gestor_clientes_get_all_datasource.dart';
import 'package:cangurugestor/datasource/gestor/gestor_cuidadores_get_all_datasource.dart';
import 'package:cangurugestor/domain/entity/gestor_entity.dart';
import 'package:cangurugestor/presentation/state/gestor_state.dart';
import 'package:flutter/material.dart';

class GestorController extends ValueNotifier<GestorState> {
  final GestorCuidadoresGetAllDatasource _gestorCuidadoresGetAllDatasource =
      GestorCuidadoresGetAllDatasource();
  final GestorClientesGetAllDatasource _gestorClientesGetAllDatasource =
      GestorClientesGetAllDatasource();
  GestorController() : super(GestorInitialState());

  load(GestorEntity gestor) async {
    value = GestorLoadingState();
    gestor.clientes = await _gestorClientesGetAllDatasource(gestor);
    gestor.cuidadores = await _gestorCuidadoresGetAllDatasource(gestor);
    value = GestorSuccessState(gestor);
  }
}
