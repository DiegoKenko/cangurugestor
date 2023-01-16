import 'package:cangurugestor/autentication/auth_login.dart';
import 'package:cangurugestor/firebaseUtils/fire_login.dart';
import 'package:cangurugestor/model/gestor.dart';
import 'package:flutter/cupertino.dart';

class LoginProvider extends ChangeNotifier {
  final FirestoreLogin firestoreLogin = FirestoreLogin();
  bool _isLoading = false;
  bool _isLogged = false;
  bool _hasError = false;
  MethodLogin loginMethod = const MethodLogin();
  bool get isLoading => _isLoading;
  bool get isLogged => _isLogged;
  bool get hasError => _hasError;
  Gestor gestor = Gestor();

  setLoginMethod(MethodLogin login) {
    loginMethod = login;
    notifyListeners();
  }

  void sucess(Gestor gestor) {
    _isLogged = true;
    _hasError = false;
    _isLoading = false;
    this.gestor = gestor;
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
      Gestor user = await googleLogin.loadUser();
      user.id.isEmpty ? fail() : sucess(user);
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
