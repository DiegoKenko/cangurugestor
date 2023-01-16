import 'package:cangurugestor/model/gestor.dart';
import 'package:cangurugestor/model/responsavel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreGestor {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<List<Responsavel>> todosClientesGestor(Gestor gestor) async {
    List<Responsavel> resps = [];
    for (var element in gestor.idClientes) {
      var doc = await firestore.collection('responsaveis').doc(element).get();
      Responsavel responsavel = Responsavel.fromMap(doc.data()!);
      responsavel.id = doc.id;
      resps.add(responsavel);
    }
    return resps;
  }
}
