import 'package:cangurugestor/datasource/gestor/gestor_create_datasource.dart';
import 'package:cangurugestor/datasource/login/gestor/login_gestor_update_datasource.dart';
import 'package:cangurugestor/domain/entity/gestor.dart';

class GestorCreateUsecase {
  GestorCreateDatasource gestorCreateDatasource;
  LoginGestorUpdateDatasource loginGestorUpdateDatasource;

  GestorCreateUsecase(
      this.gestorCreateDatasource, this.loginGestorUpdateDatasource);

  call(GestorEntity gestor) async {
    await gestorCreateDatasource(gestor);
    await loginGestorUpdateDatasource(gestor);
  }
}
