import 'package:cangurugestor/domain/entity/login.dart';

abstract class AuthState {
  AuthState({
    this.loading = false,
    required this.login,
    this.error = '',
  });

  bool loading = false;
  LoginEntity login;
  String error;
}

class InitialAtuthState extends AuthState {
  InitialAtuthState() : super(loading: false, login: LoginEntity());
}

class LoadingAuthState extends AuthState {
  LoadingAuthState() : super(loading: true, login: LoginEntity());
}

class LoggedInAuthState extends AuthState {
  LoggedInAuthState(LoginEntity login) : super(loading: false, login: login) {}
}

class FirstLoginAuthState extends AuthState {
  FirstLoginAuthState(LoginEntity login) : super(loading: false, login: login);
}

class NotLoggedInAuthState extends AuthState {
  NotLoggedInAuthState() : super(loading: false, login: LoginEntity());
}

class ErrorAuthState extends AuthState {
  ErrorAuthState(String message, LoginEntity login)
      : super(loading: false, error: message, login: login);
}
