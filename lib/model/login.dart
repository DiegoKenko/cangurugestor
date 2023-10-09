import 'package:cangurugestor/global.dart';
import 'package:cangurugestor/model/cuidador.dart';
import 'package:cangurugestor/model/gestor.dart';
import 'package:cangurugestor/model/pessoa.dart';
import 'package:cangurugestor/model/responsavel.dart';
import 'package:cangurugestor/view/telas/cuid/cuid_painel.dart';
import 'package:cangurugestor/view/telas/gest/gest_painel.dart';
import 'package:cangurugestor/view/telas/resp/resp_painel.dart';
import 'package:cangurugestor/view/telas/tela_login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Login {
  Login();
  Login.init(
    this.pessoa,
    this.user,
  );
  User? user;
  Pessoa pessoa = Pessoa();

  EnumClasse get classe {
    if (pessoa is Gestor) {
      return EnumClasse.gestor;
    } else if (pessoa is Cuidador) {
      return EnumClasse.cuidador;
    } else if (pessoa is Responsavel) {
      return EnumClasse.responsavel;
    } else {
      return EnumClasse.naoDefinido;
    }
  }

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
