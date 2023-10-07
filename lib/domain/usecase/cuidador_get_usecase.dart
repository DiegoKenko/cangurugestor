import 'package:cangurugestor/datasource/cuidador/cuidador_get_datasource.dart';
import 'package:cangurugestor/domain/entity/cuidador_entity.dart';
import 'package:cangurugestor/domain/entity/default_error_entity.dart';
import 'package:result_dart/result_dart.dart';

class CuidadorGetUsecase {
  CuidadorGetDatasource cuidadorGetDatasource = CuidadorGetDatasource();

  Future<Result<CuidadorEntity, DefaultErrorEntity>> call(
    String cuidadorId,
  ) async {
    return await cuidadorGetDatasource(cuidadorId);
  }
}
