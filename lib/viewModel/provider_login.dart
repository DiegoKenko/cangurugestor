import 'package:cangurugestor/autentication/auth_login.dart';
import 'package:cangurugestor/global.dart';
import 'package:cangurugestor/model/cuidador.dart';
import 'package:cangurugestor/model/gestor.dart';
import 'package:cangurugestor/model/login.dart';
import 'package:cangurugestor/model/pessoa.dart';
import 'package:cangurugestor/model/responsavel.dart';
import 'package:cangurugestor/view/telas/cuid/cuid_painel.dart';
import 'package:cangurugestor/view/telas/gest/gest_painel.dart';
import 'package:cangurugestor/view/telas/resp/resp_painel.dart';
import 'package:cangurugestor/view/telas/tela_login.dart';
import 'package:cangurugestor/viewModel/activity_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:cangurugestor/global.dart' as global;

class LoginProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool _isLogged = false;
  bool _hasError = false;
  bool get isLoading => _isLoading;
  bool get isLogged => _isLogged;
  bool get hasError => _hasError;
  Login _login = Login();

  Pessoa get user => _login.user;
  EnumClasse get classe => _login.classe;
  Widget get route => _login.route ?? const TelaLogin();
  MethodLogin get loginMethod => _login.method;

  bool get editPaciente {
    return _login.privilegio == global.privilegioGestor;
  }

  bool get editCuidador {
    return _login.privilegio == global.privilegioGestor;
  }

  bool get editResponsavel {
    return _login.privilegio == global.privilegioGestor;
  }

  bool get editMedicamento {
    return _login.privilegio == global.privilegioGestor;
  }

  bool get editConsulta {
    return _login.privilegio == global.privilegioGestor;
  }

  bool get editAtividade {
    return _login.privilegio == global.privilegioGestor;
  }

  bool get editTarefa {
    return _login.privilegio == global.privilegioGestor;
  }

  bool get realizarTarefa {
    return _login.privilegio == global.privilegioCuidador;
  }

  bool get gerarRelatorio {
    return _login.privilegio == global.privilegioGestor;
  }

  set method(MethodLogin method) {
    _login.method = method;
  }

  void sucess() {
    _isLogged = true;
    _hasError = false;
    _isLoading = false;
    ActivityViewModel.login(_login.user);
    notifyListeners();
  }

  void setLoading() {
    _isLoading = true;
    resetLogin();
    notifyListeners();
  }

  void resetLogin() {
    _login.user = Pessoa();
    _login.classe = EnumClasse.naoDefinido;
    _login.route = Container();
    _login.privilegio = 0;
  }

  void fail() {
    _isLoading = false;
    _hasError = true;
    _isLogged = false;
    resetLogin();
    notifyListeners();
  }

  Future<void> login() async {
    setLoading();
    if (loginMethod is GoogleLogin) {
      final GoogleLogin googleLogin = GoogleLogin();
      _login.user = await googleLogin.loadUser();
    } else if (loginMethod is EmailSenhaLogin) {
      final EmailSenhaLogin emailSenhaLogin = loginMethod as EmailSenhaLogin;
      _login.user = await emailSenhaLogin.loadUser();
    } else if (loginMethod is AnonymousLogin) {
      final AnonymousLogin anonymousLogin = AnonymousLogin();
      _login.user = await anonymousLogin.loadUser();
    } else {
      fail();
    }
    if (_login.user is Gestor) {
      _login.classe = EnumClasse.gestor;
      _login.route = const PainelGestor();
      _login.privilegio = global.privilegioGestor;
    } else if (_login.user is Cuidador) {
      _login.classe = EnumClasse.cuidador;
      _login.route = const PainelCuidador();
      _login.privilegio = global.privilegioCuidador;
    } else if (_login.user is Responsavel) {
      _login.classe = EnumClasse.responsavel;
      _login.route = const PainelResponsavel();
      _login.privilegio = global.privilegioResponsavel;
    } else {
      _login.classe = EnumClasse.naoDefinido;
      _login.route = Container();
    }
    _login.user.id.isEmpty ? fail() : sucess();
  }

  Future<void> logout() async {
    if (loginMethod is GoogleLogin) {
      final GoogleLogin googleLogin = GoogleLogin();
      await googleLogin.logout();
      clear();
      notifyListeners();
    }
  }

  void clear() {
    _isLogged = false;
    _hasError = false;
    _isLoading = false;
    _login = Login();
  }
}
