import 'package:cangurugestor/global.dart';
import 'package:cangurugestor/model/responsavel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ResponsavelGetDatasource {
  Future<Responsavel> get(String id) async {
    Responsavel responsavel = Responsavel();
    if (id.isEmpty) {
      return responsavel;
    }
    await getIt<FirebaseFirestore>()
        .collection('responsaveis')
        .doc(id)
        .get()
        .then((doc) {
      if (doc.data() != null) {
        responsavel = Responsavel.fromMap(doc.data()!);
        responsavel.id = doc.id;
      }
    });
    return responsavel;
  }
}
