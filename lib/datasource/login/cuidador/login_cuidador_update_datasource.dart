import 'package:cangurugestor/const/enum/enum_classe.dart';
import 'package:cangurugestor/const/global.dart';
import 'package:cangurugestor/domain/entity/cuidador_entity.dart';
import 'package:cangurugestor/domain/entity/default_error_entity.dart';
import 'package:cangurugestor/domain/entity/user_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:result_dart/result_dart.dart';

class LoginCuidadorUpdateDatasource {
  Future<Result<UserEntity, DefaultErrorEntity>> call(
    CuidadorEntity cuidador,
  ) async {
    if (cuidador.id.isEmpty && cuidador.email.isNotEmpty) {
      QuerySnapshot<Map<String, dynamic>> snap =
          await getIt<FirebaseFirestore>()
              .collection('login')
              .where('funcaoId', isEqualTo: cuidador.id)
              .where('funcao', isEqualTo: EnumClasse.cuidador.name)
              .get();

      if (snap.docs.isEmpty) {
        return UserEntity.fromMap(snap.docs.first.data()).toSuccess();
      }
      return Failure(DefaultErrorEntity('Error ao fazer login'));
    }
    return Failure(DefaultErrorEntity('Error ao fazer login'));
  }
}
