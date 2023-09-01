import 'package:cangurugestor/datasource/gestor/gestor_get_datasource.dart';
import 'package:cangurugestor/domain/entity/default_error_entity.dart';
import 'package:cangurugestor/domain/entity/gestor_entity.dart';
import 'package:result_dart/result_dart.dart';

class GestorGetUsecase {
  Future<Result<GestorEntity, DefaultErrorEntity>> call(String email) async {
    GestorGetDatasource gestorGetDatasource = GestorGetDatasource();
    GestorEntity? gestor = await gestorGetDatasource(email)
        .fold((success) => success, (error) => null);
    if (gestor == null) {
      return Failure(DefaultErrorEntity('Gestor não encontrado'));
    }
    return gestor.toSuccess();
  }
}
