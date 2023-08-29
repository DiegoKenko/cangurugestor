import 'package:cangurugestor/datasource/login/responsavel/login_responsavel_update_datasource.dart';
import 'package:cangurugestor/datasource/responsavel/responsavel_update_datasource.dart';

class ResponsavelCreateUsecase {
  ResponsavelUpdateDatasource responsavelUpdateDatasource;
  LoginResponsavelUpdateDatasource loginResponsavelUpdateDatasource;

  ResponsavelCreateUsecase(
      this.responsavelUpdateDatasource, this.loginResponsavelUpdateDatasource);
}
