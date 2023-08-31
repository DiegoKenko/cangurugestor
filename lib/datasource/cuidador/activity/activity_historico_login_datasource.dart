import 'package:cangurugestor/const/global.dart';
import 'package:cangurugestor/domain/entity/activity_login_entity.dart';
import 'package:cangurugestor/domain/entity/cuidador_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ActivityHistoricoLoginDatasource {
  Future<List<LoginActivityEntity>> call(CuidadorEntity cuidador) async {
    final List<LoginActivityEntity> list = <LoginActivityEntity>[];
    QuerySnapshot<Map<String, dynamic>> doc = await getIt<FirebaseFirestore>()
        .collection('cuidadores')
        .doc(cuidador.id)
        .collection('activities')
        .where('name', isEqualTo: 'login')
        .orderBy('date')
        .orderBy('time')
        .get();
    for (var element in doc.docs) {
      list.add(LoginActivityEntity.fromJson(element.data()));
    }
    return list;
  }
}
