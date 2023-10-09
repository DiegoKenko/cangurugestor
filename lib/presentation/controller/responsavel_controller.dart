import 'package:cangurugestor/datasource/responsavel/responsavel_create_datasource.dart';
import 'package:cangurugestor/datasource/responsavel/responsavel_delete_datasource.dart';
import 'package:cangurugestor/datasource/responsavel/responsavel_paciente_get_all_datasource.dart';
import 'package:cangurugestor/datasource/responsavel/responsavel_update_datasource.dart';
import 'package:cangurugestor/domain/entity/responsavel_entity.dart';
import 'package:cangurugestor/presentation/state/responsavel_state.dart';
import 'package:flutter/foundation.dart';
import 'package:result_dart/result_dart.dart';

class ResponsavelController extends ValueNotifier<ResponsavelState> {
  final ResponsavelPacienteGetAllDatasource
      _responsavelPacienteGetAllDatasource =
      ResponsavelPacienteGetAllDatasource();
  final ResponsavelCreateDatasource _responsavelCreateDatasource =
      ResponsavelCreateDatasource();
  final ResponsavelUpdateDatasource _responsavelUpdateDatasource =
      ResponsavelUpdateDatasource();
  final ResponsavelDeleteDatasource _responsavelDeleteDatasource =
      ResponsavelDeleteDatasource();
  ResponsavelController(this.responsavel) : super(ResponsavelInitialState());

  ResponsavelEntity responsavel;

  init(ResponsavelEntity responsavel) {
    this.responsavel = responsavel;
    loadPacientes(responsavel);
  }

  loadPacientes(ResponsavelEntity responsavel) async {
    value = ResponsavelLoadingState();
    responsavel.pacientes =
        await _responsavelPacienteGetAllDatasource(responsavel);
    value = ResponsavelSuccessState(responsavel);
  }

  update() async {
    value = ResponsavelLoadingState();
    if (responsavel.id.isEmpty) {
      await _responsavelCreateDatasource(responsavel).fold(
        (success) {
          responsavel = success;
        },
        (error) => null,
      );
    } else {
      await _responsavelUpdateDatasource(responsavel);
    }
    value = ResponsavelSuccessState(responsavel);
  }

  delete(ResponsavelEntity responsavel) async {
    value = ResponsavelLoadingState();
    await _responsavelDeleteDatasource(responsavel);
    value = ResponsavelSuccessState(responsavel);
  }
}
