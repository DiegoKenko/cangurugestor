import 'package:cangurugestor/const/global.dart';
import 'package:cangurugestor/domain/entity/default_error_entity.dart';
import 'package:cangurugestor/domain/entity/responsavel_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:result_dart/result_dart.dart';

class ResponsavelUpdateDatasource {
  Future<Result<ResponsavelEntity, DefaultErrorEntity>> call(
    ResponsavelEntity responsavel,
  ) async {
    if (responsavel.id.isEmpty) {
      return Failure(DefaultErrorEntity('message'));
    }
    try {
      await getIt<FirebaseFirestore>()
          .collection('responsaveis')
          .doc(responsavel.id)
          .update(responsavel.toMap());
      return responsavel.toSuccess();
    } catch (e) {
      return Failure(DefaultErrorEntity('message'));
    }
  }
}
