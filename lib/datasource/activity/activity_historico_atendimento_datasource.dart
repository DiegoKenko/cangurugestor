import 'package:cangurugestor/enum/enum_classe.dart';
import 'package:cangurugestor/global.dart';
import 'package:cangurugestor/model/activity.dart';
import 'package:cangurugestor/model/cuidador.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ActivityHistoricoAtendimentoDatasource {
  Future<List<TarefaActivity>> call(
    Cuidador cuidador,
  ) async {
    final List<TarefaActivity> list = <TarefaActivity>[];
    QuerySnapshot<Map<String, dynamic>> doc = await getIt<FirebaseFirestore>()
        .collection('cuidadores')
        .doc(cuidador.id)
        .collection('activities')
        .where('name', isEqualTo: 'tarefa')
        .orderBy('date')
        .orderBy('time')
        .get();
    for (var element in doc.docs) {
      list.add(TarefaActivity.fromJson(element.data()));
    }
    return list;
  }
}
