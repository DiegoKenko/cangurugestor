import 'package:cangurugestor/datasource/cuidador/cuidador_create_datasource.dart';
import 'package:cangurugestor/datasource/login/cuidador/login_cuidador_update_datasource.dart';
import 'package:cangurugestor/domain/entity/cuidador_entity.dart';

class CuidadorCreateUsecase {
  CuidadorCreateDatasource cuidadorCreateDatasource =
      CuidadorCreateDatasource();
  LoginCuidadorUpdateDatasource loginDatasource =
      LoginCuidadorUpdateDatasource();

  CuidadorCreateUsecase();

  call(CuidadorEntity cuidador) async {
    await cuidadorCreateDatasource(cuidador);
    await loginDatasource(cuidador);
  }
}
