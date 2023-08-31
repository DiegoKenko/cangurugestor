import 'package:cangurugestor/const/global.dart';
import 'package:cangurugestor/domain/entity/gestor_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GestorGetDatasource {
  Future<GestorEntity> call(String id) async {
    var doc =
        await getIt<FirebaseFirestore>().collection('gestores').doc(id).get();
    if (doc.data() != null) {
      GestorEntity gestor = GestorEntity.fromMap(doc.data()!);
      gestor.id = doc.id;
      return gestor;
    } else {
      return GestorEntity();
    }
  }
}
