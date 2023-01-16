import 'package:cangurugestor/model/gestor.dart';
import 'package:cangurugestor/model/responsavel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreGestor {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<List<Responsavel>> todosClientesGestor(Gestor gestor) async {
    var snap = await firestore
        .collection('responsaveis')
        .where('gestor', isEqualTo: gestor.id)
        .get();
    return snap.docs.map((e) {
      var responsavel = Responsavel.fromMap(e.data());
      responsavel.id = e.id;
      return responsavel;
    }).toList();
  }
}
