import 'package:cangurugestor/datasource/cuidador/activity/activity_login_datasource.dart';
import 'package:cangurugestor/datasource/cuidador/activity/activity_tarefa_datasource.dart';
import 'package:cangurugestor/domain/entity/activity_login_entity.dart';
import 'package:cangurugestor/domain/entity/activity_tarefa_entity.dart';
import 'package:cangurugestor/domain/entity/cuidador_entity.dart';
import 'package:cangurugestor/domain/entity/paciente_entity.dart';
import 'package:cangurugestor/domain/entity/pessoa_entity.dart';
import 'package:cangurugestor/domain/entity/tarefa_entity.dart';
import 'package:cangurugestor/presentation/state/activity_state.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ActivityController extends ValueNotifier<ActivityState> {
  final ActivityLoginDatasource activityLoginDatasource =
      ActivityLoginDatasource();
  final ActivityTarefaDatasource activityTarefaDatasource =
      ActivityTarefaDatasource();
  ActivityController() : super(InitialActivityState());

  addLogin(PessoaEntity user) {
    LoginActivityEntity activity = LoginActivityEntity(
      userId: user.id,
      activityId: user.id,
      activityDate: DateFormat('dd/MM/yyyy').format(DateTime.now()),
      activityTime: DateFormat('HH:mm').format(DateTime.now()),
    );

    activityLoginDatasource(activity);
  }

  addTarefa(
    TarefaEntity tarefa,
    CuidadorEntity cuidador,
    PacienteEntity paciente,
  ) {
    TarefaActivityEntity activity = TarefaActivityEntity(
      tarefaId: tarefa.id,
      pacienteId: paciente.id,
      userId: cuidador.id,
      activityDescription: 'realização da terefa',
      activityDate: DateFormat('dd/MM/yyyy').format(DateTime.now()),
      activityTime: DateFormat('HH:mm').format(DateTime.now()),
    );
    activityTarefaDatasource(activity);
  }
}
