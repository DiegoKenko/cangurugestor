import 'package:cangurugestor/const/global.dart';
import 'package:cangurugestor/domain/entity/default_error_entity.dart';
import 'package:cangurugestor/domain/entity/responsavel_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:result_dart/result_dart.dart';

class ResponsavelGetDatasource {
  Future<Result<ResponsavelEntity, DefaultErrorEntity>> get(String id) async {
    if (id.isEmpty) {
      return Failure(DefaultErrorEntity('Id não informado'));
    }
    try {
      return await getIt<FirebaseFirestore>()
          .collection('responsaveis')
          .doc(id)
          .get()
          .then((doc) {
        if (doc.data() != null) {
          ResponsavelEntity? responsavel;
          responsavel = ResponsavelEntity.fromMap(doc.data()!);
          responsavel.id = doc.id;
          return responsavel.toSuccess();
        } else {
          return Failure(DefaultErrorEntity('Id não informado'));
        }
      });
    } catch (e) {
      return Failure(DefaultErrorEntity('Id não informado'));
    }
  }
}
