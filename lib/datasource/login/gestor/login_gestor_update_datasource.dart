import 'package:cangurugestor/global.dart';
import 'package:cangurugestor/model/gestor.dart';
import 'package:cangurugestor/model/login_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginGestorUpdateDatasource {
  Future<void> atualizaLoginGestor(Gestor gestor) async {
    final LoginUser user = LoginUser.fromGestor(gestor);
    if (user.doc.isNotEmpty && user.email.isNotEmpty) {
      await getIt<FirebaseFirestore>()
          .collection('login')
          .where('doc', isEqualTo: user.doc)
          .get()
          .then((value) {
        if (value.docs.isNotEmpty) {
          value.docs.first.reference.update(user.toMap());
        } else {
          getIt<FirebaseFirestore>().collection('login').add(user.toMap());
        }
      });
    }
  }
}
