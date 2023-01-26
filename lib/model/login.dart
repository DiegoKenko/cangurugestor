import 'package:cangurugestor/autentication/auth_login.dart';
import 'package:cangurugestor/global.dart';
import 'package:cangurugestor/model/pessoa.dart';
import 'package:flutter/material.dart';

class Login {
  MethodLogin method = MethodLogin();
  Pessoa user = Pessoa();
  EnumClasse classe = EnumClasse.naoDefinido;
  Widget? route;
  int privilegio = privilegioNenhum;
}
