import 'package:cangurugestor/const/enum/enum_auth.dart';
import 'package:cangurugestor/datasource/login/login_autenticar.dart';
import 'package:cangurugestor/domain/entity/default_error_entity.dart';
import 'package:cangurugestor/domain/entity/login_entity.dart';
import 'package:cangurugestor/domain/entity/pessoa_entity.dart';
import 'package:cangurugestor/service/autentication/auth_login.dart';
import 'package:cangurugestor/presentation/state/auth_state.dart';
import 'package:cangurugestor/const/enum/enum_classe.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:result_dart/result_dart.dart';

class AuthController extends ValueNotifier<AuthState> {
  final LoginAuntenticarDatasource _loginAuntenticarDatasource =
      LoginAuntenticarDatasource();

  AuthController() : super(InitialAtuthState());

  EnumClasse? get role {
    if (value is SuccessAuthState) {
      return (value as SuccessAuthState).login.classe;
    }
    return null;
  }

  LoginEntity? get current {
    if (value is SuccessAuthState) {
      return (value as SuccessAuthState).login;
    }
    return null;
  }

  Future<Result<LoginEntity, DefaultErrorEntity>> getLogin() async {
    User? user = await _getUser().fold((success) => success, (error) => null);
    if (user == null) {
      return Failure(DefaultErrorEntity('Erro ao carregar usuário'));
    }

    PessoaEntity? pessoa =
        await _loginAuntenticarDatasource(user.email!).fold((success) {
      return success;
    }, (error) {
      return null;
    });
    if (pessoa == null) {
      return Failure(DefaultErrorEntity('Erro ao carregar usuário'));
    } else {
      return LoginEntity.init(pessoa, user).toSuccess();
    }
  }

  Future<Result<User, DefaultErrorEntity>> _getUser() async {
    final GoogleLogin googleLogin = GoogleLogin();
    User? user = await googleLogin.loadUser();
    if (user == null) {
      return Failure(DefaultErrorEntity('Erro ao carregar usuário'));
    } else {
      return user.toSuccess();
    }
  }

  Future<void> login(EnumMethodAuthID method) async {
    value = LoadingAuthState();
    User? user;
    if (method == EnumMethodAuthID.google) {
      final GoogleLogin googleLogin = GoogleLogin();
      user = await googleLogin.loadUser();
    } else if (method == EnumMethodAuthID.apple) {}
    if (user == null) {
      value = ErrorAuthState();
    } else {
      await _loginAuntenticarDatasource(user.email!).fold((success) {
        value = SuccessAuthState(LoginEntity.init(success, user));
      }, (error) {
        value = ErrorAuthState();
      });
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
    }
  }
}
