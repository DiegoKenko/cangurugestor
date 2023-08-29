import 'package:cangurugestor/enum/enum_classe.dart';
import 'package:cangurugestor/datasource/firebase_auth_constants.dart';
import 'package:flutter/material.dart' show immutable;

@immutable
abstract class AuthEvent {}

class LogoutEvent extends AuthEvent {
  LogoutEvent();
}

class InitEvent extends AuthEvent {
  InitEvent();
}

class LoginEvent extends AuthEvent {
  final EnumMethodAuthID methodAuthID;
  LoginEvent(this.methodAuthID);
}

class CreateLoginEvent extends AuthEvent {
  final EnumClasse classeEscolhida;
  CreateLoginEvent(
    this.classeEscolhida,
  );
}
