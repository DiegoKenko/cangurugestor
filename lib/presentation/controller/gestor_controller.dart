import 'package:cangurugestor/datasource/gestor/gestor_clientes_get_all_datasource.dart';
import 'package:cangurugestor/datasource/gestor/gestor_cuidadores_get_all_datasource.dart';
import 'package:cangurugestor/domain/entity/gestor_entity.dart';
import 'package:cangurugestor/domain/usecase/gestor_get_usecase.dart';
import 'package:cangurugestor/presentation/state/gestor_state.dart';
import 'package:flutter/material.dart';
import 'package:result_dart/result_dart.dart';

class GestorController extends ValueNotifier<GestorState> {
  final GestorCuidadoresGetAllDatasource _gestorCuidadoresGetAllDatasource =
      GestorCuidadoresGetAllDatasource();
  final GestorClientesGetAllDatasource _gestorClientesGetAllDatasource =
      GestorClientesGetAllDatasource();
  final GestorGetUsecase _gestorGetUsecase = GestorGetUsecase();
  GestorEntity gestor;
  GestorController(this.gestor) : super(GestorInitialState());

  init(String id) {
    _load(id);
  }

  loadClientes() async {
    value = GestorLoadingState();
    gestor.clientes = await _gestorClientesGetAllDatasource(gestor);
    value = GestorSuccessState(gestor);
  }

  loadCuidadores() async {
    value = GestorLoadingState();
    gestor.cuidadores = await _gestorCuidadoresGetAllDatasource(gestor);
    value = GestorSuccessState(gestor);
  }

  _load(String id) async {
    value = GestorLoadingState();
    await _gestorGetUsecase(id).fold((success) {
      gestor = success;
      value = GestorSuccessState(gestor);
    }, (error) {
      value = GestorErrorState(error.message);
    });
  }
}
