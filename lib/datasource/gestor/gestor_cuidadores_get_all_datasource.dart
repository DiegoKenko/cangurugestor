import 'package:cangurugestor/global.dart';
import 'package:cangurugestor/model/cuidador.dart';
import 'package:cangurugestor/model/gestor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GestorCuidadoresGetAllDatasource {
  Future<List<Cuidador>> todosCuidadoresGestor(Gestor gestor) async {
    QuerySnapshot<Map<String, dynamic>> snap = await getIt<FirebaseFirestore>()
        .collection('cuidadores')
        .where('idGestor', isEqualTo: gestor.id)
        .get();

    if (snap.docs.isEmpty) {
      return [];
    }

    return snap.docs.map((e) {
      Cuidador cuidador = Cuidador.fromMap(e.data());
      cuidador.id = e.id;
      return cuidador;
    }).toList();
  }
}
