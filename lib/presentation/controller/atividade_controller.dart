import 'package:cangurugestor/datasource/paciente/atividade/atividade_paciente_create_datasource.dart';
import 'package:cangurugestor/datasource/paciente/atividade/atividade_paciente_delete_datasource.dart';
import 'package:cangurugestor/datasource/paciente/atividade/atividade_paciente_update_datasource.dart';
import 'package:cangurugestor/domain/entity/atividade_entity.dart';
import 'package:cangurugestor/presentation/state/atividade_state.dart';
import 'package:flutter/material.dart';

class AtividadeController extends ValueNotifier<AtividadeState> {
  final AtividadePacienteDeleteDatasource atividadePacienteDeleteDatasource =
      AtividadePacienteDeleteDatasource();
  final AtividadePacienteUpdateDatasource atividadePacienteUpdateDatasource =
      AtividadePacienteUpdateDatasource();
  final AtividadePacienteCreateDatasource atividadePacienteCreateDatasource =
      AtividadePacienteCreateDatasource();
  AtividadeController() : super(AtividadeInitialState());

  load(AtividadeEntity atividade) {
    value = AtividadeInitialState();
  }

  delete(AtividadeEntity atividade) async {
    await atividadePacienteDeleteDatasource(
      atividade.id,
      atividade.paciente.id,
    );
    value = AtividadeInitialState();
  }

  update(AtividadeEntity atividade) async {
    if (atividade.id.isNotEmpty) {
      atividadePacienteUpdateDatasource(atividade, atividade.paciente.id);
    } else {
      atividade = await atividadePacienteCreateDatasource(
        atividade,
        atividade.paciente.id,
      );
    }
    atividade = atividade;
    value = AtividadeInitialState();
  }
}
