import 'package:cangurugestor/domain/entity/cuidador_entity.dart';
import 'package:cangurugestor/domain/usecase/cuidador_create_usecase.dart';
import 'package:cangurugestor/domain/usecase/cuidador_update_usecase.dart';
import 'package:cangurugestor/presentation/state/cuidador_state.dart';

import 'package:flutter/material.dart';

class CuidadorController extends ValueNotifier<CuidadorState> {
  final CuidadorCreateUsecase cuidadorCreateUsecase = CuidadorCreateUsecase();
  final CuidadorUpdateUsecase cuidadorUpdateUsecase = CuidadorUpdateUsecase();

  CuidadorController() : super(CuidadorInitialState());

  update(CuidadorEntity cuidador) async {
    value = CuidadorLoadingState();
    if (cuidador.id.isEmpty) {
      cuidador = await cuidadorCreateUsecase(cuidador);
    } else {
      await cuidadorUpdateUsecase(cuidador);
    }
    value = CuidadorSuccessState(cuidador);
  }

  delete(CuidadorEntity cuidador) async {}
}
