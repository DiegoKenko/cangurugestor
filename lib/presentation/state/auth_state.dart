import 'package:cangurugestor/domain/entity/user_entity.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthState {}

class InitialAtuthState extends AuthState {
  InitialAtuthState() : super();
}

class UnauthenticatedAuthState extends AuthState {
  User? user;
  UnauthenticatedAuthState(this.user) : super();
}

class AuthenticatedAuthState extends AuthState {
  LoginEntity user;
  AuthenticatedAuthState(this.user) : super();
}

class LoadingAuthState extends AuthState {
  LoadingAuthState() : super();
}

class ErrorAuthState extends AuthState {
  ErrorAuthState() : super();
}
