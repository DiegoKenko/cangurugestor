import 'package:cangurugestor/const/global.dart';
import 'package:cangurugestor/domain/entity/default_error_entity.dart';
import 'package:cangurugestor/domain/entity/gestor_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:result_dart/result_dart.dart';

class GestorGetDatasource {
  Future<Result<GestorEntity, DefaultErrorEntity>> call(String id) async {
    var doc =
        await getIt<FirebaseFirestore>().collection('gestores').doc(id).get();
    if (doc.data() == null) {
      return Failure(DefaultErrorEntity('Gestor não encontrado'));
    }
    GestorEntity gestor = GestorEntity.fromMap(doc.data()!);
    gestor.id = doc.id;
    return gestor.toSuccess();
  }
}
