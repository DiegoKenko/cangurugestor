import 'package:cangurugestor/const/global.dart';
import 'package:cangurugestor/datasource/atividade/atividade_paciente_create_datasource.dart';
import 'package:cangurugestor/datasource/atividade/atividade_paciente_delete_datasource.dart';
import 'package:cangurugestor/datasource/atividade/atividade_paciente_update_datasource.dart';
import 'package:cangurugestor/domain/entity/atividade.dart';
import 'package:cangurugestor/presentation/state/atividade_state.dart';
import 'package:flutter/material.dart';

class AtividadeController extends ValueNotifier<AtividadeState> {
  final AtividadePacienteDeleteDatasource atividadePacienteDeleteDatasource =
      getIt<AtividadePacienteDeleteDatasource>();
  final AtividadePacienteUpdateDatasource atividadePacienteUpdateDatasource =
      getIt<AtividadePacienteUpdateDatasource>();
  final AtividadePacienteCreateDatasource atividadePacienteCreateDatasource =
      getIt<AtividadePacienteCreateDatasource>();
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