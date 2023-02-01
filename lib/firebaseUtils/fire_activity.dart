import 'package:cangurugestor/global.dart';
import 'package:cangurugestor/model/activity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreActivity {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> addActivity(Activity activity) async {
    await firestore
        .collection(activity.classe.collection)
        .doc(activity.userId)
        .collection('activities')
        .add(activity.toJson());
  }
}
