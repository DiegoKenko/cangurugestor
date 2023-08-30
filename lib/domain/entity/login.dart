import 'package:cangurugestor/const/enum/enum_classe.dart';
import 'package:cangurugestor/domain/entity/cuidador.dart';
import 'package:cangurugestor/domain/entity/gestor.dart';
import 'package:cangurugestor/domain/entity/pessoa.dart';
import 'package:cangurugestor/domain/entity/responsavel.dart';
import 'package:cangurugestor/presentation/view/telas/cuid/cuid_painel.dart';
import 'package:cangurugestor/presentation/view/telas/gest/gest_painel.dart';
import 'package:cangurugestor/presentation/view/telas/resp/resp_painel.dart';
import 'package:cangurugestor/presentation/view/telas/tela_login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginEntity {
  LoginEntity();
  LoginEntity.init(
    this.pessoa,
    this.user,
  );
  User? user;
  PessoaEntity pessoa = PessoaEntity();

  EnumClasse get classe {
    if (pessoa is GestorEntity) {
      return EnumClasse.gestor;
    } else if (pessoa is CuidadorEntity) {
      return EnumClasse.cuidador;
    } else if (pessoa is ResponsavelEntity) {
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
