import 'package:cangurugestor/const/global.dart';
import 'package:cangurugestor/domain/entity/default_error_entity.dart';
import 'package:cangurugestor/domain/entity/responsavel_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:result_dart/result_dart.dart';

class ResponsavelCreateDatasource {
  Future<Result<ResponsavelEntity, DefaultErrorEntity>> call(
    ResponsavelEntity responsavel,
  ) async {
    try {
      DocumentReference<Map<String, dynamic>> doc =
          await getIt<FirebaseFirestore>()
              .collection('resposaveis')
              .add(responsavel.toMap());
      responsavel.id = doc.id;

      return responsavel.toSuccess();
    } catch (e) {
      return Failure(DefaultErrorEntity('message'));
    }
  }
}
