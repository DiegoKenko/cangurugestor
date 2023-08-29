import 'package:cangurugestor/global.dart';
import 'package:cangurugestor/model/activity.dart';
import 'package:cangurugestor/model/cuidador.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ActivityHistoricoLoginDatasource {
  Future<List<LoginActivity>> call(Cuidador cuidador) async {
    final List<LoginActivity> list = <LoginActivity>[];
    QuerySnapshot<Map<String, dynamic>> doc = await getIt<FirebaseFirestore>()
        .collection('cuidadores')
        .doc(cuidador.id)
        .collection('activities')
        .where('name', isEqualTo: 'login')
        .orderBy('date')
        .orderBy('time')
        .get();
    for (var element in doc.docs) {
      list.add(LoginActivity.fromJson(element.data()));
    }
    return list;
  }
}
