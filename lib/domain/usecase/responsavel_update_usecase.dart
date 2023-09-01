import 'package:cangurugestor/datasource/login/responsavel/login_responsavel_update_datasource.dart';
import 'package:cangurugestor/datasource/responsavel/responsavel_create_datasource.dart';
import 'package:cangurugestor/datasource/responsavel/responsavel_update_datasource.dart';
import 'package:cangurugestor/domain/entity/default_error_entity.dart';
import 'package:cangurugestor/domain/entity/responsavel_entity.dart';
import 'package:result_dart/result_dart.dart';

class ResponsavelUpdateUsecase {
  ResponsavelUpdateDatasource reponsavelUpdateDatasource =
      ResponsavelUpdateDatasource();
  ResponsavelCreateDatasource reponsavelCreateDatasource =
      ResponsavelCreateDatasource();
  LoginResponsavelUpdateDatasource loginResponsavelUpdateDatasource =
      LoginResponsavelUpdateDatasource();

  ResponsavelUpdateUsecase();

  Future<Result<ResponsavelEntity, DefaultErrorEntity>> call(
    ResponsavelEntity responsavel,
  ) async {
    await reponsavelUpdateDatasource(responsavel).fold(
      (success) {
        responsavel = success;
      },
      (error) {
        responsavel = ResponsavelEntity();
      },
    );
    await reponsavelCreateDatasource(responsavel).fold(
      (success) => responsavel = success,
      (error) => responsavel = ResponsavelEntity(),
    );
    if (responsavel.id.isEmpty) {
      return Failure(DefaultErrorEntity('Error ao criar responsavel'));
    } else {
      await loginResponsavelUpdateDatasource(responsavel);
      return responsavel.toSuccess();
    }
  }
}
