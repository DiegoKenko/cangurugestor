import 'package:cangurugestor/const/global.dart';
import 'package:cangurugestor/domain/entity/cuidador_entity.dart';
import 'package:cangurugestor/domain/entity/login_user_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginCuidadorUpdateDatasource {
  Future<void> call(CuidadorEntity cuidador) async {
    final LoginUserEntity user = LoginUserEntity.fromCuidador(cuidador);
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
