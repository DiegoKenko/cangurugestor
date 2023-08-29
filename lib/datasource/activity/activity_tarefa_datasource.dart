import 'package:cangurugestor/enum/enum_classe.dart';
import 'package:cangurugestor/model/activity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:cangurugestor/global.dart';

class ActivityTarefaDatasource {
  Future<void> call(TarefaActivity activity) async {
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
