import 'package:cangurugestor/datasource/cuidador/cuidador_create_datasource.dart';
import 'package:cangurugestor/datasource/login/cuidador/login_cuidador_update_datasource.dart';
import 'package:cangurugestor/domain/entity/cuidador.dart';

class CuidadorCreateUsecase {
  CuidadorCreateDatasource cuidadorCreateDatasource;
  LoginCuidadorUpdateDatasource loginDatasource;

  CuidadorCreateUsecase(this.cuidadorCreateDatasource, this.loginDatasource);

  call(CuidadorEntity cuidador) async {
    await cuidadorCreateDatasource(cuidador);
    await loginDatasource(cuidador);
  }
}
