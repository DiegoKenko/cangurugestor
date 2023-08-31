import 'package:cangurugestor/const/global.dart';
import 'package:cangurugestor/datasource/paciente/consulta/consulta_paciente_create_datasource.dart';
import 'package:cangurugestor/datasource/paciente/consulta/consulta_paciente_delete_datasource.dart';
import 'package:cangurugestor/datasource/paciente/consulta/consulta_paciente_update_datasource.dart';
import 'package:cangurugestor/domain/entity/consulta_entity.dart';
import 'package:cangurugestor/presentation/state/consulta_state.dart';
import 'package:flutter/material.dart';

class ConsultaController extends ValueNotifier<ConsultaState> {
  final ConsultaPacienteDeleteDatasource consultaPacienteDeleteDatasource =
      getIt<ConsultaPacienteDeleteDatasource>();
  final ConsultaPacienteUpdateDatasource consultaPacienteUpdateDatasource =
      getIt<ConsultaPacienteUpdateDatasource>();
  final ConsultaPacienteCreateDatasource consultaPacienteCreateDatasource =
      getIt<ConsultaPacienteCreateDatasource>();
  ConsultaController() : super(ConsultaInitialState());

  load() {
    value = ConsultaInitialState();
  }

  delete(ConsultaEntity consulta) async {
    await consultaPacienteDeleteDatasource(
      consulta.id,
      consulta.paciente.id,
    );
    value = ConsultaInitialState();
  }

  update(ConsultaEntity consulta) async {
    if (consulta.id.isNotEmpty) {
      await consultaPacienteUpdateDatasource(consulta, consulta.paciente.id);
    } else {
      consulta = await consultaPacienteCreateDatasource(
        consulta,
        consulta.paciente.id,
      );
    }
    value = ConsultaInitialState();
  }
}
