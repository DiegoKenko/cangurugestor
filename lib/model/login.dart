import 'package:cangurugestor/autentication/auth_login.dart';
import 'package:cangurugestor/global.dart';
import 'package:cangurugestor/model/login_user.dart';
import 'package:flutter/material.dart';

class Login {
  MethodLogin method = MethodLogin();
  LoginUser user = LoginUser();
  EnumClasse classe = EnumClasse.naoDefinido;
  Widget? route;
  int privilegio = privilegioNenhum;
}
