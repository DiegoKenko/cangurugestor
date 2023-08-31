import 'package:cangurugestor/datasource/cuidador/activity/activity_historico_atendimento_datasource.dart';
import 'package:cangurugestor/datasource/cuidador/activity/activity_historico_login_datasource.dart';
import 'package:cangurugestor/domain/entity/activity_login_entity.dart';
import 'package:cangurugestor/domain/entity/activity_tarefa_entity.dart';
import 'package:cangurugestor/domain/entity/cuidador_entity.dart';
import 'package:cangurugestor/domain/entity/gestor_entity.dart';
import 'package:cangurugestor/domain/entity/paciente_entity.dart';
import 'package:cangurugestor/domain/entity/responsavel_entity.dart';
import 'package:cangurugestor/presentation/state/relatorio_gestor_acesso_state.dart';
import 'package:flutter/material.dart';

class RelatorioGestorAcessosController
    extends ValueNotifier<RelatorioGestorAcessoState> {
  RelatorioGestorAcessosController()
      : super(InitialRelatorioGestorAcessoState());

  final ActivityHistoricoAtendimentoDatasource
      activityHistoricoAtendimentoDatasource =
      ActivityHistoricoAtendimentoDatasource();
  final ActivityHistoricoLoginDatasource activityHistoricoLoginDatasource =
      ActivityHistoricoLoginDatasource();
  final List<ResponsavelEntity> _clientes = [];
  final List<CuidadorEntity> _cuidadores = [];
  final List<PacienteEntity> _pacientes = [];
  GestorEntity gestor = GestorEntity();

  List<LoginActivityEntity> _logins = [];
  List<TarefaActivityEntity> _atendimentos = [];
  CuidadorEntity cuidador = CuidadorEntity();

  List<LoginActivityEntity> get logins => _logins;
  List<TarefaActivityEntity> get atendimentos => _atendimentos;

  List<ResponsavelEntity> get clientes => _clientes;
  List<CuidadorEntity> get cuidadores => _cuidadores;
  List<PacienteEntity> get pacientes => _pacientes;

  void load() {
    loadActivity();
    loadAtendimento();
  }

  Future<void> loadActivity() async {
    _logins = await activityHistoricoLoginDatasource(cuidador);
  }

  Future<void> loadAtendimento() async {
    _atendimentos = await activityHistoricoAtendimentoDatasource(cuidador);
  }
}
