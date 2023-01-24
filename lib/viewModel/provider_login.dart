import 'package:cangurugestor/autentication/auth_login.dart';
import 'package:cangurugestor/global.dart';
import 'package:cangurugestor/model/cuidador.dart';
import 'package:cangurugestor/model/gestor.dart';
import 'package:cangurugestor/model/login_user.dart';
import 'package:cangurugestor/model/responsavel.dart';
import 'package:cangurugestor/view/telas/cuid/cuid_painel.dart';
import 'package:cangurugestor/view/telas/gest/gest_painel.dart';
import 'package:cangurugestor/view/telas/resp/resp_painel.dart';
import 'package:flutter/cupertino.dart';
import 'package:cangurugestor/global.dart' as global;

class LoginProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool _isLogged = false;
  bool _hasError = false;
  MethodLogin _loginMethod = MethodLogin();
  LoginUser _user = LoginUser();
  EnumClasse _classe = EnumClasse.naoDefinido;
  Widget? _route;
  int _privilegio = global.privilegioNenhum;

  bool get isLoading => _isLoading;
  bool get isLogged => _isLogged;
  bool get hasError => _hasError;
  int get privilegio => _privilegio;
  LoginUser get user => _user;
  EnumClasse get classe => _classe;
  Widget? get route => _route;

  MethodLogin get loginMethod => _loginMethod;

  setLoginMethod(MethodLogin login) {
    _loginMethod = login;
    notifyListeners();
  }

  void sucess() {
    _isLogged = true;
    _hasError = false;
    _isLoading = false;
    notifyListeners();
  }

  void setLoading() {
    _isLoading = true;
    notifyListeners();
  }

  void resetLoading() {
    _isLoading = false;
    notifyListeners();
  }

  void fail() {
    _isLoading = false;
    _hasError = true;
    _isLogged = false;
    notifyListeners();
  }

  void login() async {
    setLoading();
    if (loginMethod is GoogleLogin) {
      final GoogleLogin googleLogin = GoogleLogin();
      _user = await googleLogin.loadUser();
      if (_user is Gestor) {
        _classe = EnumClasse.gestor;
        _route = const PainelGestor();
        _privilegio = global.privilegioGestor;
      } else if (_user is Cuidador) {
        _classe = EnumClasse.cuidador;
        _route = const PainelCuidador();
        _privilegio = global.privilegioCuidador;
      } else if (_user is Responsavel) {
        _classe = EnumClasse.responsavel;
        _route = const PainelResponsavel();
        _privilegio = global.privilegioResponsavel;
      } else {
        _classe = EnumClasse.naoDefinido;
        _route = Container();
      }
      _user.id.isEmpty ? fail() : sucess();
    }
  }

  void logout() async {
    if (loginMethod is GoogleLogin) {
      final GoogleLogin googleLogin = GoogleLogin();
      await googleLogin.logout();
      _isLogged = false;
      _hasError = false;
      _isLoading = false;
      notifyListeners();
    }
  }
}
