import 'package:cangurugestor/const/global.dart';
import 'package:cangurugestor/datasource/gestor/gestor_clientes_get_all_datasource.dart';
import 'package:cangurugestor/datasource/gestor/gestor_cuidadores_get_all_datasource.dart';
import 'package:cangurugestor/domain/entity/gestor_entity.dart';
import 'package:cangurugestor/presentation/state/gestor_state.dart';
import 'package:flutter/material.dart';

class GestorController extends ValueNotifier<GestorState> {
  final GestorCuidadoresGetAllDatasource gestorCuidadoresGetAllDatasource =
      getIt<GestorCuidadoresGetAllDatasource>();
  final GestorClientesGetAllDatasource gestorClientesGetAllDatasource =
      getIt<GestorClientesGetAllDatasource>();
  GestorController() : super(GestorInitialState());

  loadClientes(GestorEntity gestor) async {
    value = GestorLoadingState();
    gestor.clientes = await gestorClientesGetAllDatasource(gestor);
    value = GestorSuccessState(gestor);
  }

  loadCuidadores(GestorEntity gestor) async {
    value = GestorLoadingState();
    gestor.cuidadores = await gestorCuidadoresGetAllDatasource(gestor);
    value = GestorSuccessState(gestor);
  }
}
