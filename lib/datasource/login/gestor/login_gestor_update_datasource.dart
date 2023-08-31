import 'package:cangurugestor/const/global.dart';
import 'package:cangurugestor/domain/entity/gestor_entity.dart';
import 'package:cangurugestor/domain/entity/login_user_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginGestorUpdateDatasource {
  Future<void> call(GestorEntity gestor) async {
    final LoginUserEntity user = LoginUserEntity.fromGestor(gestor);
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
