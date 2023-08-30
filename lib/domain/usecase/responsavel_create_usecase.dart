import 'package:cangurugestor/datasource/login/responsavel/login_responsavel_update_datasource.dart';
import 'package:cangurugestor/datasource/responsavel/responsavel_create_datasource.dart';
import 'package:cangurugestor/domain/entity/responsavel.dart';

class ResponsavelCreateUsecase {
  ResponsavelCreateDatasource reponsavelCreateDatasource;
  LoginResponsavelUpdateDatasource loginResponsavelUpdateDatasource;

  ResponsavelCreateUsecase(
      this.reponsavelCreateDatasource, this.loginResponsavelUpdateDatasource);

  call(ResponsavelEntity responsavel) async {
    await reponsavelCreateDatasource(responsavel);
    await loginResponsavelUpdateDatasource(responsavel);
  }
}
