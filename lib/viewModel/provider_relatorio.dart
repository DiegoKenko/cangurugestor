import 'package:cangurugestor/firebaseUtils/fire_activity.dart';
import 'package:cangurugestor/firebaseUtils/fire_gestor.dart';
import 'package:cangurugestor/model/activity.dart';
import 'package:cangurugestor/model/cuidador.dart';
import 'package:cangurugestor/model/gestor.dart';
import 'package:cangurugestor/model/paciente.dart';
import 'package:cangurugestor/model/responsavel.dart';
import 'package:flutter/material.dart';

class RelatorioProviderGestor extends ChangeNotifier {
  RelatorioProviderGestor({required this.gestor}) {
    loadCuidadoresGestor();
    loadClientesGestor();
  }
  List<Responsavel> _clientes = [];
  List<Cuidador> _cuidadores = [];
  final List<Paciente> _pacientes = [];
  Gestor gestor = Gestor();

  List<Responsavel> get clientes => _clientes;
  List<Cuidador> get cuidadores => _cuidadores;
  List<Paciente> get pacientes => _pacientes;

  Future<void> loadCuidadoresGestor() async {
    _cuidadores = await FirestoreGestor().todosCuidadoresGestor(gestor);
  }

  Future<void> loadClientesGestor() async {
    _clientes = await FirestoreGestor().todosClientesGestor(gestor);
  }
}

class RelatorioProviderCuidador extends ChangeNotifier {
  RelatorioProviderCuidador({required this.cuidador}) {
    load();
  }
  List<LoginActivity> _logins = [];
  List<TarefaActivity> _atendimentos = [];
  Cuidador cuidador = Cuidador();

  List<LoginActivity> get logins => _logins;
  List<TarefaActivity> get atendimentos => _atendimentos;

  void load() {
    loadActivity();
    loadAtendimento();
  }

  Future<void> loadActivity() async {
    _logins = await FirestoreActivity().historicoLoginCuidador(cuidador);
  }

  Future<void> loadAtendimento() async {
    _atendimentos =
        await FirestoreActivity().historicoAtendimentoCuidador(cuidador);
  }
}
