import 'package:cangurugestor/model/login.dart';
import 'package:cangurugestor/viewModel/activity_viewmodel.dart';

abstract class AuthState {
  AuthState({
    this.loading = false,
    required this.login,
    this.error = '',
  });

  bool loading = false;
  Login login;
  String error;
}

class InitialAtuthState extends AuthState {
  InitialAtuthState() : super(loading: false, login: Login());
}

class LoadingAuthState extends AuthState {
  LoadingAuthState(Login login) : super(loading: true, login: login);
}

class LoggedInAuthState extends AuthState {
  LoggedInAuthState(Login login) : super(loading: false, login: login) {
    ActivityViewModel.login(login.pessoa);
  }
}

class FirstLoginAuthState extends AuthState {
  FirstLoginAuthState(Login login) : super(loading: false, login: login);
}

class NotLoggedInAuthState extends AuthState {
  NotLoggedInAuthState(Login login) : super(loading: false, login: login);
}

class ErrorAuthState extends AuthState {
  ErrorAuthState(String message, Login login)
      : super(loading: false, error: message, login: login);
}
