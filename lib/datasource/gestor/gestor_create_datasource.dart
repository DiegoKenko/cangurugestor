import 'package:cangurugestor/const/global.dart';
import 'package:cangurugestor/domain/entity/default_error_entity.dart';
import 'package:cangurugestor/domain/entity/gestor_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:result_dart/result_dart.dart';

class GestorCreateDatasource {
  Future<Result<GestorEntity, DefaultErrorEntity>> call(
    GestorEntity gestor,
  ) async {
    try {
      if (gestor.id.isNotEmpty) {
        await getIt<FirebaseFirestore>()
            .collection('gestores')
            .doc(gestor.id)
            .set(gestor.toMap());
      } else {
        DocumentReference<Map<String, dynamic>> doc =
            await getIt<FirebaseFirestore>()
                .collection('gestores')
                .add(gestor.toMap());
        gestor.id = doc.id;
      }

      return gestor.toSuccess();
    } catch (e) {
      return Failure(DefaultErrorEntity('message'));
    }
  }
}
