import 'package:cangurugestor/global.dart';
import 'package:cangurugestor/model/gestor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GestorUpdateDatasource{
   Future<Gestor> update(Gestor gestor) async {
    await getIt<FirebaseFirestore>()
        .collection('gestores')
        .doc(gestor.id)
        .update(gestor.toMap());
    return gestor;
  }
}