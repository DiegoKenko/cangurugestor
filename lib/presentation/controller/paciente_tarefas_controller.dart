import 'package:cangurugestor/const/enum/enum_intervalo.dart';
import 'package:cangurugestor/const/enum/enum_tarefa.dart';
import 'package:cangurugestor/datasource/paciente/atividade/atividade_paciente_get_datasource.dart';
import 'package:cangurugestor/datasource/paciente/consulta/consulta_paciente_get_datasource.dart';
import 'package:cangurugestor/datasource/paciente/medicamento/medicamento_paciente_get_datasource.dart';
import 'package:cangurugestor/datasource/tarefa/tarefa_create_datasource.dart';
import 'package:cangurugestor/datasource/tarefa/tarefa_delete_datasource.dart';
import 'package:cangurugestor/datasource/tarefa/tarefa_get_amanha_datasource.dart';
import 'package:cangurugestor/datasource/tarefa/tarefa_get_hoje_datasource.dart';
import 'package:cangurugestor/datasource/tarefa/tarefa_get_ontem_datasource.dart';
import 'package:cangurugestor/datasource/tarefa/tarefa_get_semana_datasource.dart';
import 'package:cangurugestor/datasource/tarefa/tarefa_paciente_get_all_datasource.dart';
import 'package:cangurugestor/domain/entity/atividade_entity.dart';
import 'package:cangurugestor/domain/entity/consulta_entity.dart';
import 'package:cangurugestor/domain/entity/medicamento_entity.dart';
import 'package:cangurugestor/domain/entity/paciente_entity.dart';
import 'package:cangurugestor/domain/entity/tarefa_entity.dart';
import 'package:cangurugestor/presentation/state/paciente_tarefas_state.dart';
import 'package:flutter/material.dart';

class PacienteTarefasController
    extends ValueNotifier<ListaTarefaPacienteState> {
  PacienteTarefasController() : super(ListaTarefasInitialState());
  final TarefaGetOntemDatasource getOntemDatasource =
      TarefaGetOntemDatasource();
  final TarefaGetAmanhaDatasource getAmanhaDatasource =
      TarefaGetAmanhaDatasource();
  final TarefaGetHojeDatasource getHojeDatasource = TarefaGetHojeDatasource();
  final TarefaGetSemanaDatasource getSemanaDatasource =
      TarefaGetSemanaDatasource();
  final TarefaPacienteGetAllDatasource getAllDatasource =
      TarefaPacienteGetAllDatasource();
  final TarefaDeleteDatasource tarefaDeleteDatasource =
      TarefaDeleteDatasource();
  final TarefaCreateDatasource tarefaCreateDatasource =
      TarefaCreateDatasource();
  final MedicamentoPacienteGetDatasource medicamentoPacienteGetDatasource =
      MedicamentoPacienteGetDatasource();
  final ConsultaPacienteGetDatasource consultaPacienteGetDatasource =
      ConsultaPacienteGetDatasource();
  final AtividadePacienteGetDatasource atividadePacienteGetDatasource =
      AtividadePacienteGetDatasource();

  List<TarefaEntity> tarefas = [];

  loadTarefas(EnumFiltroDataTarefa filtro, PacienteEntity paciente) async {
    switch (filtro) {
      case EnumFiltroDataTarefa.ontem:
        tarefas = await getOntemDatasource(paciente);
        break;
      case EnumFiltroDataTarefa.hoje:
        tarefas = await getHojeDatasource(paciente);
        break;
      case EnumFiltroDataTarefa.amanha:
        tarefas = await getAmanhaDatasource(paciente);
        break;
      case EnumFiltroDataTarefa.proxSemana:
        tarefas = await getSemanaDatasource(paciente);
        break;
      case EnumFiltroDataTarefa.todos:
        tarefas = await getAllDatasource(paciente);
        break;
      default:
        tarefas = await getHojeDatasource(paciente);
    }

    value = ListaTarefasSuccessState(paciente, tarefas);
  }

  add(PacienteEntity paciente, EnumTarefa tipo, String idTipo) async {
    TarefaEntity tarefa = TarefaEntity();
    if (tipo == EnumTarefa.medicamento) {
      MedicamentoEntity medicamento =
          await medicamentoPacienteGetDatasource(idTipo, paciente.id);
      if (tarefas.isEmpty) {
        tarefa = TarefaEntity.init(
          dateTime: DateTime.now(),
          nome: medicamento.nome,
          descricao: medicamento.descricao,
          observacao: medicamento.observacao,
          tipo: EnumTarefa.medicamento,
          idTipo: idTipo,
        );
      } else {
        tarefa = TarefaEntity.init(
          dateTime: tarefas.last.dateTime.add(
            Duration(
              minutes: enumIntervaloEmMinutos(
                medicamento.intervalo,
                medicamento.intervaloQuantidade,
              ).toInt(),
            ),
          ),
          nome: medicamento.nome,
          descricao: medicamento.descricao,
          observacao: medicamento.observacao,
          tipo: EnumTarefa.medicamento,
          idTipo: idTipo,
        );
      }
    } else if (tipo == EnumTarefa.consulta) {
      ConsultaEntity consulta =
          await consultaPacienteGetDatasource(idTipo, paciente.id);
      if (tarefas.isEmpty) {
        tarefa = TarefaEntity.init(
          dateTime: DateTime.now(),
          nome: consulta.descricao,
          descricao: consulta.medico,
          observacao: consulta.observacao,
          tipo: EnumTarefa.consulta,
          idTipo: idTipo,
        );
      } else {
        tarefa = TarefaEntity.init(
          dateTime: tarefas.last.dateTime.add(
            const Duration(days: 7),
          ),
          nome: consulta.descricao,
          descricao: consulta.medico,
          observacao: consulta.observacao,
          tipo: EnumTarefa.consulta,
          idTipo: idTipo,
        );
      }
    } else if (tipo == EnumTarefa.atividade) {
      AtividadeEntity atividade =
          await atividadePacienteGetDatasource(idTipo, paciente.id);
      if (tarefas.isEmpty) {
        tarefa = TarefaEntity.init(
          dateTime: DateTime.now(),
          nome: atividade.descricao,
          descricao: atividade.local,
          observacao: atividade.observacao,
          tipo: EnumTarefa.atividade,
          idTipo: idTipo,
        );
      } else {
        tarefa = TarefaEntity.init(
          dateTime: tarefas.last.dateTime.add(
            Duration(
              minutes: enumIntervaloEmMinutos(
                atividade.frequenciaMedida,
                atividade.frequenciaQuantidade,
              ).toInt(),
            ),
          ),
          nome: atividade.descricao,
          descricao: atividade.local,
          observacao: atividade.observacao,
          tipo: EnumTarefa.atividade,
          idTipo: idTipo,
        );
      }
    }

    tarefa = await tarefaCreateDatasource(paciente, tarefa);
    tarefas.add(tarefa);
    value = ListaTarefasSuccessState(
      paciente,
      tarefas,
    );
  }

  remove(PacienteEntity paciente, TarefaEntity tarefa) async {
    await tarefaDeleteDatasource(paciente.id, tarefa.id);
    tarefas.remove(tarefa);
    value = ListaTarefasSuccessState(
      paciente,
      tarefas,
    );
  }
}
