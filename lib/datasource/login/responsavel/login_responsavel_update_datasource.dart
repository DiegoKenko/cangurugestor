import 'package:cangurugestor/const/enum/enum_classe.dart';
import 'package:cangurugestor/const/global.dart';
import 'package:cangurugestor/domain/entity/default_error_entity.dart';
import 'package:cangurugestor/domain/entity/responsavel_entity.dart';
import 'package:cangurugestor/domain/entity/user_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:result_dart/result_dart.dart';

class LoginResponsavelUpdateDatasource {
  Future<Result<UserEntity, DefaultErrorEntity>> call(
    ResponsavelEntity responsavel,
  ) async {
    if (responsavel.id.isEmpty && responsavel.email.isNotEmpty) {
      QuerySnapshot<Map<String, dynamic>> snap =
          await getIt<FirebaseFirestore>()
              .collection('login')
              .where('funcaoId', isEqualTo: responsavel.id)
              .where('funcao', isEqualTo: EnumClasse.responsavel.name)
              .get();

      if (snap.docs.isEmpty) {
        return UserEntity.fromMap(snap.docs.first.data()).toSuccess();
      }
      return Failure(DefaultErrorEntity('Error ao fazer login'));
    }
    return Failure(DefaultErrorEntity('Error ao fazer login'));
  }
}
