import 'package:cangurugestor/const/global.dart';
import 'package:cangurugestor/datasource/paciente/paciente_atividade_get_all_datasource.dart';
import 'package:cangurugestor/datasource/paciente/paciente_consulta_get_all_datasource.dart';
import 'package:cangurugestor/datasource/paciente/paciente_create_datasource.dart';
import 'package:cangurugestor/datasource/paciente/paciente_cuidador_get_all_datasource.dart';
import 'package:cangurugestor/datasource/paciente/paciente_excluir_datasource.dart';
import 'package:cangurugestor/datasource/paciente/paciente_get_datasource.dart';
import 'package:cangurugestor/datasource/paciente/paciente_medicamento_get_all_datasource.dart';
import 'package:cangurugestor/datasource/paciente/paciente_update_datasource.dart';
import 'package:cangurugestor/domain/entity/cuidador_entity.dart';
import 'package:cangurugestor/domain/entity/paciente_entity.dart';
import 'package:cangurugestor/presentation/state/paciente_state.dart';
import 'package:flutter/material.dart';

class PacienteController extends ValueNotifier<PacienteState> {
  final PacienteGetDatasource pacienteGetDatasource =
      getIt<PacienteGetDatasource>();

  final PacienteCuidadorGetAllDatasource pacienteCuidadorGetAllDatasource =
      getIt<PacienteCuidadorGetAllDatasource>();
  final PacienteMedicamentoGetAllDatasource
      pacienteMedicamentoGetAllDatasource =
      getIt<PacienteMedicamentoGetAllDatasource>();
  final PacienteConsultaGetAllDatasource pacienteConsultaGetAllDatasource =
      getIt<PacienteConsultaGetAllDatasource>();
  final PacienteAtividadeGetAllDatasource pacienteAtividageGetAllDatasource =
      getIt<PacienteAtividadeGetAllDatasource>();
  final PacienteExcluirDatasource pacienteExcluirDatasource =
      getIt<PacienteExcluirDatasource>();
  final PacienteUpdateDatasource pacienteUpdateDatasource =
      getIt<PacienteUpdateDatasource>();
  final PacienteCreateDatasource pacienteCreateDatasource =
      getIt<PacienteCreateDatasource>();

  PacienteController() : super(PacienteInitialState());

  load(String idPaciente) async {
    PacienteEntity paciente = await pacienteGetDatasource(idPaciente);
  }

  loadCuidadores(PacienteEntity paciente) async {
    value = PacienteLoadingState();
    List<CuidadorEntity> cuidadores =
        await pacienteCuidadorGetAllDatasource(paciente);
    paciente.cuidadores = cuidadores;
    value = PacienteSuccessState(paciente);
  }

  loadMedicamentos(PacienteEntity paciente) async {
    value = PacienteLoadingState();
    paciente.medicamentos = await pacienteMedicamentoGetAllDatasource(paciente);
    value = PacienteSuccessState(paciente);
  }

  loadAtividades(PacienteEntity paciente) async {
    value = PacienteLoadingState();
    paciente.atividades = await pacienteAtividageGetAllDatasource(paciente);
    value = PacienteSuccessState(paciente);
  }

  loadConsultas(PacienteEntity paciente) async {
    value = PacienteLoadingState();
    paciente.consultas = await pacienteConsultaGetAllDatasource(paciente);
    value = PacienteSuccessState(paciente);
  }

  update(PacienteEntity paciente) async {
    value = PacienteLoadingState();
    if (paciente.nome.isNotEmpty) {
      if (paciente.id.isEmpty) {
        paciente = await pacienteCreateDatasource(paciente);
      } else {
        await pacienteUpdateDatasource(paciente);
      }
      value = PacienteSuccessState(paciente);
    }
  }

  delete(PacienteEntity paciente) async {
    await pacienteExcluirDatasource(paciente);
    value = PacienteSuccessState(paciente);
  }

  removerCuidador(PacienteEntity paciente, CuidadorEntity cuidador) async {
    value = PacienteLoadingState();
    if (paciente.idCuidadores.contains(cuidador.id)) {
      paciente.idCuidadores.remove(cuidador.id);
      await pacienteUpdateDatasource(paciente);
      value = PacienteSuccessState(paciente);
    }
  }

  addCuidador(PacienteEntity paciente, CuidadorEntity cuidador) async {
    value = PacienteLoadingState();
    if (!paciente.idCuidadores.contains(cuidador.id)) {
      paciente.idCuidadores.add(cuidador.id);
      await pacienteUpdateDatasource(paciente);
      value = PacienteSuccessState(paciente);
    }
  }
}
