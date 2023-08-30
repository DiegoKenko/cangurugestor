import 'package:cangurugestor/const/global.dart';
import 'package:cangurugestor/datasource/medicamento/medicamento_delete_datasource.dart';
import 'package:cangurugestor/datasource/medicamento/medicamento_paciente_add_datasource.dart';
import 'package:cangurugestor/datasource/medicamento/medicamento_update_datasource.dart';
import 'package:cangurugestor/domain/entity/medicamento.dart';
import 'package:cangurugestor/presentation/state/medicamento_state.dart';
import 'package:flutter/material.dart';

class MedicamentoController extends ValueNotifier<MedicamentoState> {
  final MedicamentoDeleteDatasource medicamentoDeleteDatasource =
      getIt<MedicamentoDeleteDatasource>();
  final MedicamentoUpdateDatasource medicamentoUpdateDatasource =
      getIt<MedicamentoUpdateDatasource>();
  final MedicamentoPacienteAddDatasource medicamentoPacienteAddDatasource =
      getIt<MedicamentoPacienteAddDatasource>();
  MedicamentoController() : super(MedicamentoInitialState());

  load() {}

  delete(MedicamentoEntity medicamento) async {
    await medicamentoDeleteDatasource(
      medicamento.id,
      medicamento.paciente.id,
    );
    value = MedicamentoInitialState();
  }

  update(MedicamentoEntity medicamento) async {
    if (medicamento.id.isNotEmpty) {
      medicamentoUpdateDatasource(
        medicamento,
        medicamento.paciente.id,
      );
    } else {
      medicamento = await medicamentoPacienteAddDatasource(
        medicamento,
        medicamento.paciente.id,
      );
      medicamento = medicamento;
    }
    value = MedicamentoInitialState();
  }
}
