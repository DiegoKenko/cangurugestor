import 'package:cangurugestor/datasource/login/responsavel/login_responsavel_update_datasource.dart';
import 'package:cangurugestor/datasource/responsavel/responsavel_create_datasource.dart';
import 'package:cangurugestor/domain/entity/responsavel_entity.dart';

class ResponsavelCreateUsecase {
  ResponsavelCreateDatasource reponsavelCreateDatasource =
      ResponsavelCreateDatasource();
  LoginResponsavelUpdateDatasource loginResponsavelUpdateDatasource =
      LoginResponsavelUpdateDatasource();

  ResponsavelCreateUsecase();

  call(ResponsavelEntity responsavel) async {
    await reponsavelCreateDatasource(responsavel);
    await loginResponsavelUpdateDatasource(responsavel);
  }
}
