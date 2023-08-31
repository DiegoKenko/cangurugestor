import 'package:cangurugestor/const/global.dart';
import 'package:cangurugestor/datasource/tarefa/tarefa_delete_datasource.dart';
import 'package:cangurugestor/datasource/tarefa/tarefa_update_datasource.dart';
import 'package:cangurugestor/domain/entity/paciente_entity.dart';
import 'package:cangurugestor/domain/entity/tarefa_entity.dart';
import 'package:cangurugestor/presentation/state/tarefa_state.dart';
import 'package:flutter/material.dart';

class TarefaController extends ValueNotifier<TarefaState> {
  final TarefaUpdateDatasource tarefaUpdateDatasource =
      getIt<TarefaUpdateDatasource>();
  final TarefaDeleteDatasource tarefaDeleteDatasource =
      getIt<TarefaDeleteDatasource>();
  TarefaController() : super(TarefaInitialState());

  Future<void> update(PacienteEntity paciente, TarefaEntity tarefa) async {
    await tarefaUpdateDatasource(paciente, tarefa);
  }

  Future<void> delete(PacienteEntity paciente, TarefaEntity tarefa) async {
    await tarefaDeleteDatasource(paciente.id, tarefa.id);
  }
}
