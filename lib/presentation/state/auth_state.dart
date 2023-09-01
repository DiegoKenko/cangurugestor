import 'package:cangurugestor/domain/entity/pessoa_entity.dart';
import 'package:cangurugestor/domain/entity/user_entity.dart';

abstract class AuthState {}

class InitialAtuthState extends AuthState {
  InitialAtuthState() : super();
}

class UnauthenticatedAuthState extends AuthState {
  UnauthenticatedAuthState() : super();
}

class AuthenticatedAuthState extends AuthState {
  UserEntity user;
  AuthenticatedAuthState(this.user) : super();
}

class LoadingAuthState extends AuthState {
  LoadingAuthState() : super();
}

class ErrorAuthState extends AuthState {
  ErrorAuthState() : super();
}
