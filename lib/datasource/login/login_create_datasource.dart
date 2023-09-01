import 'package:cangurugestor/const/global.dart';
import 'package:cangurugestor/domain/entity/default_error_entity.dart';
import 'package:cangurugestor/domain/entity/user_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:result_dart/result_dart.dart';

class LoginCreateDatasource {
  Future<Result<UserEntity, DefaultErrorEntity>> call(
    UserEntity user,
  ) async {
    try {
      DocumentReference doc = await getIt<FirebaseFirestore>()
          .collection('login')
          .add(user.toMap());
      user.docId = doc.id;
      return user.toSuccess();
    } catch (e) {
      return Failure(DefaultErrorEntity('Falha ao criar login'));
    }
  }
}
