import 'package:cangurugestor/datasource/login/responsavel/login_responsavel_update_datasource.dart';
import 'package:cangurugestor/datasource/responsavel/responsavel_create_datasource.dart';
import 'package:cangurugestor/domain/entity/default_error_entity.dart';
import 'package:cangurugestor/domain/entity/responsavel_entity.dart';
import 'package:result_dart/result_dart.dart';

class ResponsavelUpdateUsecase {
  ResponsavelUpdateUsecase();

  Future<Result<ResponsavelEntity, DefaultErrorEntity>> call(
    ResponsavelEntity responsavel,
  ) async {
    await ResponsavelCreateDatasource().call(responsavel).fold(
      (success) {
        responsavel = success;
      },
      (error) {},
    );
    if (responsavel.id.isEmpty) {
      return Failure(DefaultErrorEntity('Error ao criar responsavel'));
    } else {
      await LoginResponsavelUpdateDatasource().call(responsavel);
      return responsavel.toSuccess();
    }
  }
}
