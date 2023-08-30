import 'package:cangurugestor/const/global.dart';
import 'package:cangurugestor/domain/entity/login_user.dart';
import 'package:cangurugestor/domain/entity/responsavel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginResponsavelUpdateDatasource {
  Future<void> call(ResponsavelEntity responsavel) async {
    final LoginUserEntity user = LoginUserEntity.fromResponsavel(responsavel);
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
