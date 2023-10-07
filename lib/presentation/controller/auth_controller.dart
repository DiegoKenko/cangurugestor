import 'package:cangurugestor/const/enum/enum_auth.dart';
import 'package:cangurugestor/domain/entity/cuidador_entity.dart';
import 'package:cangurugestor/domain/entity/default_error_entity.dart';
import 'package:cangurugestor/domain/entity/gestor_entity.dart';
import 'package:cangurugestor/domain/entity/pessoa_entity.dart';
import 'package:cangurugestor/domain/entity/responsavel_entity.dart';
import 'package:cangurugestor/domain/entity/user_entity.dart';
import 'package:cangurugestor/domain/usecase/auth_login_usecase.dart';
import 'package:cangurugestor/service/autentication/auth_login.dart';
import 'package:cangurugestor/presentation/state/auth_state.dart';
import 'package:cangurugestor/const/enum/enum_classe.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:result_dart/result_dart.dart';

class AuthController extends ValueNotifier<AuthState> {
  final AuthLoginUseCase authLoginUseCase = AuthLoginUseCase();

  PessoaEntity? _pessoaEntity;
  AuthController() : super(InitialAtuthState());

  EnumClasse? get role {
    if (_pessoaEntity != null) {
      if (_pessoaEntity is CuidadorEntity) {
        return EnumClasse.cuidador;
      }
      if (_pessoaEntity is CuidadorEntity) {
        return EnumClasse.responsavel;
      }
      if (_pessoaEntity is CuidadorEntity) {
        return EnumClasse.gestor;
      }
    }
    return null;
  }

  PessoaEntity? get current {
    return _pessoaEntity;
  }

  Future<PessoaEntity?> checkLogin() async {
    value = LoadingAuthState();
    final GoogleLogin googleLogin = GoogleLogin();
    final User? user = googleLogin.currentUser();
    if (user == null) {
      value = UnauthenticatedAuthState(user);
      return null;
    }
    return await _checkLogin(user).fold((success) {
      _pessoaEntity = success;
      value = AuthenticatedAuthState(LoginEntity.fromPessoa(success));
      return success;
    }, (error) {
      value = UnauthenticatedAuthState(user);
      return null;
    });
  }

  Future<PessoaEntity?> createLogin(User user, EnumClasse classe) async {
    PessoaEntity? pessoaEntity;
    return await authLoginUseCase(user: user, classe: classe).fold(
      (success) {
        LoginEntity loginEntity =
            LoginEntity.fromPessoa(success, funcao: classe);
        value = AuthenticatedAuthState(loginEntity);
        if (classe == EnumClasse.cuidador) {
          pessoaEntity = CuidadorEntity.fromPessoa(success);
        }
        if (classe == EnumClasse.responsavel) {
          pessoaEntity = ResponsavelEntity.fromPessoa(success);
        }
        if (classe == EnumClasse.gestor) {
          pessoaEntity = GestorEntity.fromPessoa(success);
        }

        return pessoaEntity;
      },
      (error) => null,
    );
  }

  Future<Result<PessoaEntity, DefaultErrorEntity>> _checkLogin(
      User user) async {
    PessoaEntity? pessoa = await authLoginUseCase(user: user).fold((success) {
      return success;
    }, (error) {
      return null;
    });
    if (pessoa == null) {
      return Failure(DefaultErrorEntity(''));
    } else {
      return pessoa.toSuccess();
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
      await authLoginUseCase(user: user).fold((success) {
        value = AuthenticatedAuthState(LoginEntity.fromPessoa(success));
      }, (error) {
        value = ErrorAuthState();
      });
    }
    if (user == null) {
      value = UnauthenticatedAuthState(user);
      return;
    } else {
      await _checkLogin(user).fold((success) {
        _pessoaEntity = success;
        value = AuthenticatedAuthState(LoginEntity.fromPessoa(success));
      }, (error) {
        value = UnauthenticatedAuthState(user);
      });
    }
  }

  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 500));
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      if (user.providerData[0].methodLogin == EnumMethodAuthID.google) {
        await GoogleLogin().logout();
      } else if (user.providerData[0].methodLogin == EnumMethodAuthID.apple) {
      } else {}
    }
  }
}
