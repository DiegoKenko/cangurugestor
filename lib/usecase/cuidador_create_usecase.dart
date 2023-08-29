import 'package:cangurugestor/datasource/cuidador/cuidador_create_datasource.dart';
import 'package:cangurugestor/datasource/login/cuidador/login_cuidador_update_datasource.dart';

class CuidadorCreateUsecase {
  CuidadorCreateDatasource datasource;
  LoginCuidadorUpdateDatasource loginDatasource;

  CuidadorCreateUsecase(this.datasource, this.loginDatasource);
}
