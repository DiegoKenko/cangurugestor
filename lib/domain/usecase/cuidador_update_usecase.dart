import 'package:cangurugestor/datasource/cuidador/cuidador_update_datasource.dart';
import 'package:cangurugestor/datasource/login/cuidador/login_cuidador_update_datasource.dart';
import 'package:cangurugestor/domain/entity/cuidador_entity.dart';

class CuidadorUpdateUsecase {
  CuidadorUpdateDatasource cuidadorCreateDatasource =
      CuidadorUpdateDatasource();
  LoginCuidadorUpdateDatasource loginDatasource =
      LoginCuidadorUpdateDatasource();

  CuidadorUpdateUsecase();

  call(CuidadorEntity cuidador) async {
    await cuidadorCreateDatasource(cuidador);
    await loginDatasource(cuidador);
  }
}
