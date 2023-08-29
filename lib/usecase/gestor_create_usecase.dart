import 'package:cangurugestor/datasource/gestor/gestor_create_datasource.dart';
import 'package:cangurugestor/datasource/login/gestor/login_gestor_update_datasource.dart';

class GestorCreateUsecase {
  GestorCreateDatasource gestorCreateDatasource;
  LoginGestorUpdateDatasource loginGestorUpdateDatasource;

  GestorCreateUsecase(
      this.gestorCreateDatasource, this.loginGestorUpdateDatasource);
}
