import 'package:cangurugestor/model/gestor.dart';
import 'package:cangurugestor/model/responsavel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreGestor {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<List<Responsavel>> todosClientesGestor(Gestor gestor) async {
    List<Responsavel> resps = [];
    await firestore.collection('gestores').doc(gestor.id).get().then((doc) {
      if (doc.data() != null) {
        gestor = Gestor.fromMap(doc.data()!);
        gestor.id = doc.id;
      }
    });

    for (var element in gestor.idClientes) {
      var doc = await firestore.collection('responsaveis').doc(element).get();
      if (doc.data() != null) {
        Responsavel responsavel = Responsavel.fromMap(doc.data()!);
        responsavel.id = doc.id;
        resps.add(responsavel);
      }
    }
    return resps;
  }
}
