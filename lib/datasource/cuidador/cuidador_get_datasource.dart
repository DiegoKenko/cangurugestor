import 'package:cangurugestor/const/global.dart';
import 'package:cangurugestor/domain/entity/cuidador_entity.dart';
import 'package:cangurugestor/domain/entity/default_error_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:result_dart/result_dart.dart';

class CuidadorGetDatasource {
  Future<Result<CuidadorEntity, DefaultErrorEntity>> call(String id) async {
    var doc =
        await getIt<FirebaseFirestore>().collection('cuidadores').doc(id).get();
    if (doc.data() == null) {
      return Failure(DefaultErrorEntity('Cuidador não encontrado'));
    }
    CuidadorEntity gestor = CuidadorEntity.fromMap(doc.data()!);
    gestor.id = doc.id;
    return gestor.toSuccess();
  }
}
