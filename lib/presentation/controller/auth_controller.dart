import 'package:cangurugestor/const/enum/enum_auth.dart';
import 'package:cangurugestor/datasource/login/login_autenticar.dart';
import 'package:cangurugestor/domain/entity/cuidador_entity.dart';
import 'package:cangurugestor/domain/entity/gestor_entity.dart';
import 'package:cangurugestor/domain/entity/login_entity.dart';
import 'package:cangurugestor/domain/entity/pessoa_entity.dart';
import 'package:cangurugestor/domain/entity/responsavel_entity.dart';
import 'package:cangurugestor/domain/usecase/cuidador_create_usecase.dart';
import 'package:cangurugestor/domain/usecase/gestor_create_usecase.dart';
import 'package:cangurugestor/domain/usecase/responsavel_create_usecase.dart';
import 'package:cangurugestor/service/autentication/auth_login.dart';
import 'package:cangurugestor/presentation/state/auth_state.dart';
import 'package:cangurugestor/const/enum/enum_classe.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthController extends ValueNotifier<AuthState> {
  final LoginAuntenticarDatasource loginAuntenticarDatasource =
      LoginAuntenticarDatasource();
  final GestorCreateUsecase gestorCreateUsecase = GestorCreateUsecase();
  final CuidadorCreateUsecase cuidadorCreateUsecase = CuidadorCreateUsecase();
  final ResponsavelCreateUsecase responsavelCreateUsecase =
      ResponsavelCreateUsecase();

  AuthController() : super(InitialAtuthState());

  init(EnumMethodAuthID method) async {
    var user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await login(method);
    } else {
      value = NotLoggedInAuthState();
    }
  }

  Future login(EnumMethodAuthID method) async {
    value = LoadingAuthState();
    User? user;
    LoginEntity login = LoginEntity();
    if (method == EnumMethodAuthID.google) {
      final GoogleLogin googleLogin = GoogleLogin();
      user = await googleLogin.loadUser();
      login = LoginEntity.init(login.pessoa, login.user);
    } else if (method == EnumMethodAuthID.apple) {}

    if (user == null) {
      value = ErrorAuthState();
    } else {
      login.pessoa = await loginAuntenticarDatasource(user.email!);
      if (login.pessoa.id.isEmpty) {
        login.pessoa = PessoaEntity.fromUser(user);
      }
    }
  }

  createLogin(EnumClasse classe, LoginEntity login) async {
    value = LoadingAuthState();
    if (classe == EnumClasse.gestor) {
      await gestorCreateUsecase(GestorEntity.fromPessoa(login.pessoa));
    } else if (classe == EnumClasse.cuidador) {
      await cuidadorCreateUsecase(CuidadorEntity.fromPessoa(login.pessoa));
    } else if (classe == EnumClasse.responsavel) {
      await responsavelCreateUsecase(
          ResponsavelEntity.fromPessoa(login.pessoa),);
    }
  }

  logout() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      value = ErrorAuthState();
    } else {
      if (user.providerData[0].methodLogin == EnumMethodAuthID.google) {
        await GoogleLogin().logout();
      } else if (user.providerData[0].methodLogin == EnumMethodAuthID.apple) {
      } else {
        value = ErrorAuthState();
      }
      value = NotLoggedInAuthState();
    }
  }
}
