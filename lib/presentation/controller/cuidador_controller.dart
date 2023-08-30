import 'package:cangurugestor/const/global.dart';
import 'package:cangurugestor/domain/entity/cuidador.dart';
import 'package:cangurugestor/domain/usecase/cuidador_create_usecase.dart';
import 'package:cangurugestor/domain/usecase/cuidador_update_usecase.dart';
import 'package:cangurugestor/presentation/state/cuidador_state.dart';

import 'package:flutter/material.dart';

class CuidadorBloc extends ValueNotifier<CuidadorState> {
  final CuidadorCreateUsecase cuidadorCreateUsecase =
      getIt<CuidadorCreateUsecase>();
  final CuidadorUpdateUsecase cuidadorUpdateUsecase =
      getIt<CuidadorUpdateUsecase>();

  CuidadorBloc() : super(CuidadorInitialState());

  update(CuidadorEntity cuidador) async {
    value = CuidadorLoadingState();
    if (cuidador.id.isEmpty) {
      cuidador = await cuidadorCreateUsecase(cuidador);
    } else {
      await cuidadorUpdateUsecase(cuidador);
    }
    value = CuidadorReadyState(cuidador);
  }

  delete(CuidadorEntity cuidador) async {}
}
