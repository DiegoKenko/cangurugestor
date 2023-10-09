import 'package:cangurugestor/domain/entity/cuidador_entity.dart';
import 'package:cangurugestor/domain/usecase/cuidador_create_usecase.dart';
import 'package:cangurugestor/domain/usecase/cuidador_get_usecase.dart';
import 'package:cangurugestor/domain/usecase/cuidador_update_usecase.dart';
import 'package:cangurugestor/presentation/state/cuidador_state.dart';

import 'package:flutter/material.dart';

class CuidadorController extends ValueNotifier<CuidadorState> {
  final CuidadorCreateUsecase cuidadorCreateUsecase = CuidadorCreateUsecase();
  final CuidadorUpdateUsecase cuidadorUpdateUsecase = CuidadorUpdateUsecase();
  final CuidadorGetUsecase cuidadorGetUsecase = CuidadorGetUsecase();
  CuidadorEntity cuidador;
  CuidadorController(this.cuidador) : super(CuidadorInitialState());

  Future<void> load(String cuidadorId) async {
    await cuidadorGetUsecase(cuidadorId);
  }

  Future<void> update(CuidadorEntity cuidador) async {
    value = CuidadorLoadingState();
    if (cuidador.id.isEmpty) {
      cuidador = await cuidadorCreateUsecase(cuidador);
    } else {
      await cuidadorUpdateUsecase(cuidador);
    }
    value = CuidadorSuccessState(cuidador);
  }

  Future<void> delete(CuidadorEntity cuidador) async {}
}
