import 'package:cangurugestor/model/cuidador.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreCuidador {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<Cuidador> create(Cuidador cuidador) async {
    var doc = await firestore.collection('cuidadores').add(cuidador.toMap());
    cuidador.id = doc.id;
    return cuidador;
  }

  Future<Cuidador> read(String id) async {
    var doc = await firestore.collection('cuidadores').doc(id).get();
    if (doc.data() != null) {
      Cuidador cuidador = Cuidador.fromMap(doc.data()!);
      cuidador.id = doc.id;
      return cuidador;
    } else {
      return Cuidador();
    }
  }

  Future<Cuidador> update(Cuidador cuidador) async {
    await firestore
        .collection('cuidadores')
        .doc(cuidador.id)
        .update(cuidador.toMap());
    return cuidador;
  }

  Future<void> delete(Cuidador cuidador) async {
    await firestore.collection('cuidadores').doc(cuidador.id).delete();
  }
}
