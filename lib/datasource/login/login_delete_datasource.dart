import 'package:cangurugestor/const/global.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginDeleteDatasource {
  void deleteLogin(String doc) {
    getIt<FirebaseFirestore>()
        .collection('login')
        .where('doc', isEqualTo: doc)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        value.docs.first.reference.delete();
      }
    });
  }
}
