import 'package:cangurugestor/const/enum/enum_classe.dart';
import 'package:cangurugestor/const/global.dart';
import 'package:cangurugestor/domain/entity/activity_login_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ActivityLoginDatasource {
  Future<void> call(LoginActivityEntity activity) async {
    if (activity.userId.isEmpty) {
      return;
    }
    await getIt<FirebaseFirestore>()
        .collection(activity.classe.collection)
        .doc(activity.userId)
        .collection('activities')
        .add(activity.toJson());
  }
}
