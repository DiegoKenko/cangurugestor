import 'package:cangurugestor/global.dart';
import 'package:cangurugestor/model/activity.dart';
import 'package:cangurugestor/model/cuidador.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreActivity {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> addActivity(Activity activity) async {
    if (activity.userId.isEmpty) {
      return;
    }
    await firestore
        .collection(activity.classe.collection)
        .doc(activity.userId)
        .collection('activities')
        .add(activity.toJson());
  }

  Future<List<LoginAcitivity>> historicoLoginCuidador(Cuidador cuidador) async {
    final List<LoginAcitivity> list = <LoginAcitivity>[];
    QuerySnapshot<Map<String, dynamic>> doc = await firestore
        .collection('cuidadores')
        .doc(cuidador.id)
        .collection('activities')
        .where('name', isEqualTo: 'login')
        .orderBy('data')
        .orderBy('time')
        .get();
    for (var element in doc.docs) {
      list.add(LoginAcitivity.fromJson(element.data()));
    }
    return list;
  }

  Future<List<TarefaActivity>> historicoAtendimentoCuidador(
      Cuidador cuidador) async {
    final List<TarefaActivity> list = <TarefaActivity>[];
    QuerySnapshot<Map<String, dynamic>> doc = await firestore
        .collection('cuidadores')
        .doc(cuidador.id)
        .collection('activities')
        .where('name', isEqualTo: 'tarefa')
        .orderBy('data')
        .orderBy('time')
        .get();
    for (var element in doc.docs) {
      list.add(TarefaActivity.fromJson(element.data()));
    }
    return list;
  }
}
