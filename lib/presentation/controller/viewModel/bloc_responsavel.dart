import 'package:cangurugestor/const/global.dart';
import 'package:cangurugestor/datasource/responsavel/responsavel_create_datasource.dart';
import 'package:cangurugestor/datasource/responsavel/responsavel_delete_datasource.dart';
import 'package:cangurugestor/datasource/responsavel/responsavel_paciente_get_all_datasource.dart';
import 'package:cangurugestor/datasource/responsavel/responsavel_update_datasource.dart';
import 'package:cangurugestor/domain/entity/responsavel.dart';
import 'package:cangurugestor/presentation/state/responsavel_state.dart';
import 'package:flutter/foundation.dart';

class ResponsavelController extends ValueNotifier<ResponsavelState> {
  final ResponsavelPacienteGetAllDatasource
      responsavelPacienteGetAllDatasource =
      getIt<ResponsavelPacienteGetAllDatasource>();
  final ResponsavelCreateDatasource responsavelCreateDatasource =
      getIt<ResponsavelCreateDatasource>();
  final ResponsavelUpdateDatasource responsavelUpdateDatasource =
      getIt<ResponsavelUpdateDatasource>();
  final ResponsavelDeleteDatasource responsavelDeleteDatasource =
      getIt<ResponsavelDeleteDatasource>();
  ResponsavelController() : super(ResponsavelInitialState());

  loadPacientes(ResponsavelEntity responsavel) async {
    value = ResponsavelLoadingState();
    responsavel.pacientes =
        await responsavelPacienteGetAllDatasource(responsavel);
    value = ResponsavelReadyState();
  }

  update(ResponsavelEntity responsavel) async {
    value = ResponsavelLoadingState();
    if (responsavel.id.isEmpty) {
      responsavel = await responsavelCreateDatasource(responsavel);
    } else {
      await responsavelUpdateDatasource(responsavel);
    }
    value = ResponsavelReadyState();
  }

  delete(ResponsavelEntity responsavel) async {
    value = ResponsavelLoadingState();
    await responsavelDeleteDatasource(responsavel);
    value = ResponsavelReadyState();
  }
}
