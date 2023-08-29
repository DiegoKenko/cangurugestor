import 'package:cangurugestor/global.dart';
import 'package:cangurugestor/model/gestor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GestorGetDatasource {
  Future<Gestor> call(String id) async {
    var doc =
        await getIt<FirebaseFirestore>().collection('gestores').doc(id).get();
    if (doc.data() != null) {
      Gestor gestor = Gestor.fromMap(doc.data()!);
      gestor.id = doc.id;
      return gestor;
    } else {
      return Gestor();
    }
  }
}
