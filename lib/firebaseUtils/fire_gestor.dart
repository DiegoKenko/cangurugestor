import 'package:cangurugestor/classes/responsavel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreGestor {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<List<Responsavel>> todosClientesGestor(String idGestor) {
    return firestore
        .collection('responsaveis')
        .where('gestor', isEqualTo: idGestor)
        .snapshots()
        .map(
          (event) => event.docs.map((e) {
            var responsavel = Responsavel.fromMap(e.data());
            responsavel.id = e.id;
            return responsavel;
          }).toList(),
        );
  }
}
