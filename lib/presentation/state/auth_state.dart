import 'package:cangurugestor/domain/entity/login_entity.dart';

abstract class AuthState {}

class InitialAtuthState extends AuthState {
  InitialAtuthState() : super();
}

class SuccessAuthState extends AuthState {
  LoginEntity login;
  SuccessAuthState(this.login) : super();
}

class LoadingAuthState extends AuthState {
  LoadingAuthState() : super();
}

class NotLoggedInAuthState extends AuthState {
  NotLoggedInAuthState() : super();
}

class ErrorAuthState extends AuthState {
  ErrorAuthState() : super();
}
