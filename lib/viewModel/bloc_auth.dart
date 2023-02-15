import 'package:cangurugestor/autentication/auth_login.dart';
import 'package:cangurugestor/global.dart';
import 'package:cangurugestor/model/cuidador.dart';
import 'package:cangurugestor/model/gestor.dart';
import 'package:cangurugestor/model/login.dart';
import 'package:cangurugestor/model/pessoa.dart';
import 'package:cangurugestor/model/responsavel.dart';
import 'package:cangurugestor/viewModel/activity_viewmodel.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@immutable
abstract class AuthEvent {}

class LogoutEvent extends AuthEvent {
  LogoutEvent();
}

class InitEvent extends AuthEvent {
  InitEvent();
}

class LoginEvent extends AuthEvent {
  final MethodLogin method;
  LoginEvent(
    this.method,
  );
}

abstract class AuthState {
  AuthState({
    required this.loading,
    required this.login,
    this.error = '',
  });

  bool loading;
  Login login;
  String error;
}

class InitialAtuthState extends AuthState {
  InitialAtuthState() : super(loading: false, login: Login());
}

class LoadingAuthState extends AuthState {
  LoadingAuthState() : super(loading: true, login: Login());
}

class LoggedInAuthState extends AuthState {
  LoggedInAuthState({required Login xLogin})
      : super(loading: false, login: xLogin) {
    ActivityViewModel.login(login.user);
  }
}

class NotLoggedInAuthState extends AuthState {
  NotLoggedInAuthState() : super(loading: false, login: Login());
}

class ErrorAuthState extends AuthState {
  ErrorAuthState({required message})
      : super(loading: false, login: Login(), error: message);
}

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(InitialAtuthState()) {
    on<InitEvent>((event, emit) {
      var user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        if (user.providerData[0].providerId == 'google.com') {
          add(LoginEvent(GoogleLogin()));
        }
      }
    });

    on<LoginEvent>(
      (event, emit) async {
        emit(LoadingAuthState());
        Pessoa user = Pessoa();
        Function() logout = () {};
        EnumClasse classe = EnumClasse.naoDefinido;
        if (event.method is GoogleLogin) {
          final GoogleLogin googleLogin = GoogleLogin();
          user = await googleLogin.loadUser();
          logout = googleLogin.logout;
        } else if (event.method is EmailSenhaLogin) {
          final EmailSenhaLogin emailSenhaLogin =
              event.method as EmailSenhaLogin;
          user = await emailSenhaLogin.loadUser();
          logout = emailSenhaLogin.logout;
        } else if (event.method is AnonymousLogin) {
          final AnonymousLogin anonymousLogin = AnonymousLogin();
          user = await anonymousLogin.loadUser();
          logout = anonymousLogin.logout;
        }

        if (user is Gestor) {
          classe = EnumClasse.gestor;
        } else if (user is Cuidador) {
          classe = EnumClasse.cuidador;
        } else if (user is Responsavel) {
          classe = EnumClasse.responsavel;
        }

        if (user.id.isEmpty) {
          logout();
          emit(
            ErrorAuthState(
              message:
                  'Não foi possível fazer o login! Usuário não encontrado!',
            ),
          );
        } else {
          emit(
            LoggedInAuthState(
              xLogin: Login.init(
                user,
                event.method,
                classe,
              ),
            ),
          );
        }
      },
    );

    on<LogoutEvent>(
      (event, emit) async {
        if (state.login.method is GoogleLogin) {
          await GoogleLogin().logout();
        } else if (state.login.method is EmailSenhaLogin) {
          await EmailSenhaLogin(email: state.login.user.email).logout();
        } else if (state.login.method is AnonymousLogin) {
          await AnonymousLogin().logout();
        } else {
          emit(
            ErrorAuthState(message: 'Não foi possível fazer o logout!'),
          );
        }
        emit(NotLoggedInAuthState());
      },
    );
  }
}
