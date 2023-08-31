import 'package:cangurugestor/const/global.dart';
import 'package:cangurugestor/domain/entity/responsavel_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ResponsavelGetDatasource {
  Future<ResponsavelEntity> get(String id) async {
    ResponsavelEntity responsavel = ResponsavelEntity();
    if (id.isEmpty) {
      return responsavel;
    }
    await getIt<FirebaseFirestore>()
        .collection('responsaveis')
        .doc(id)
        .get()
        .then((doc) {
      if (doc.data() != null) {
        responsavel = ResponsavelEntity.fromMap(doc.data()!);
        responsavel.id = doc.id;
      }
    });
    return responsavel;
  }
}
