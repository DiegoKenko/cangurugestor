import 'package:cangurugestor/const/global.dart';
import 'package:cangurugestor/domain/entity/activity_tarefa_entity.dart';
import 'package:cangurugestor/domain/entity/cuidador_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ActivityHistoricoAtendimentoDatasource {
  Future<List<TarefaActivityEntity>> call(
    CuidadorEntity cuidador,
  ) async {
    final List<TarefaActivityEntity> list = <TarefaActivityEntity>[];
    QuerySnapshot<Map<String, dynamic>> doc = await getIt<FirebaseFirestore>()
        .collection('cuidadores')
        .doc(cuidador.id)
        .collection('activities')
        .where('name', isEqualTo: 'tarefa')
        .orderBy('date')
        .orderBy('time')
        .get();
    for (var element in doc.docs) {
      list.add(TarefaActivityEntity.fromJson(element.data()));
    }
    return list;
  }
}
