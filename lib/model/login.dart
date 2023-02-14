import 'package:cangurugestor/autentication/auth_login.dart';
import 'package:cangurugestor/global.dart';
import 'package:cangurugestor/model/pessoa.dart';
import 'package:cangurugestor/view/telas/cuid/cuid_painel.dart';
import 'package:cangurugestor/view/telas/gest/gest_painel.dart';
import 'package:cangurugestor/view/telas/resp/resp_painel.dart';
import 'package:cangurugestor/view/telas/tela_login.dart';
import 'package:cangurugestor/viewModel/provider_cuidador.dart';
import 'package:cangurugestor/viewModel/provider_gestor.dart';
import 'package:cangurugestor/viewModel/provider_responsavel.dart';
import 'package:flutter/material.dart';

class Login {
  Login();
  Login.init(
    this.user,
    this.method,
    this.classe,
  );
  MethodLogin method = MethodLogin();
  Pessoa user = Pessoa();
  EnumClasse classe = EnumClasse.naoDefinido;
  Widget get route {
    if (classe == EnumClasse.gestor) {
      return const PainelGestor();
    } else if (classe == EnumClasse.responsavel) {
      return const PainelResponsavel();
    } else if (classe == EnumClasse.cuidador) {
      return const PainelCuidador();
    } else {
      return const TelaLogin();
    }
  }

  get provider {
    if (classe == EnumClasse.gestor) {
      return GestorProvider();
    } else if (classe == EnumClasse.responsavel) {
      return ResponsavelProvider();
    } else if (classe == EnumClasse.cuidador) {
      return CuidadorProvider();
    } else {
      return const TelaLogin();
    }
  }

  bool get _isGestor => classe == EnumClasse.gestor;
  bool get _isResponsavel => classe == EnumClasse.responsavel;
  bool get _isCuidador => classe == EnumClasse.cuidador;

  bool get editaPaciente => _isGestor;
  bool get editaResponsavel => _isGestor;
  bool get editaCuidador => _isGestor;
  bool get editaMedicamento => _isGestor;
  bool get editaAtividade => _isGestor;
  bool get editaConsulta => _isGestor;
  bool get criaTarefa => _isGestor;
  bool get realizaTarefa => _isCuidador;
  bool get gerarRelatorioCuidador => _isGestor || _isResponsavel;
}
