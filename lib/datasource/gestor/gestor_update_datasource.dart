import 'package:cangurugestor/const/global.dart';
import 'package:cangurugestor/domain/entity/gestor_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GestorUpdateDatasource {
  Future<GestorEntity> call(GestorEntity gestor) async {
    await getIt<FirebaseFirestore>()
        .collection('gestores')
        .doc(gestor.id)
        .update(gestor.toMap());
    return gestor;
  }
}
