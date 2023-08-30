import 'package:cangurugestor/const/global.dart';
import 'package:cangurugestor/domain/entity/cuidador.dart';
import 'package:cangurugestor/domain/entity/gestor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GestorCuidadoresGetAllDatasource {
  Future<List<CuidadorEntity>> call(GestorEntity gestor) async {
    QuerySnapshot<Map<String, dynamic>> snap = await getIt<FirebaseFirestore>()
        .collection('cuidadores')
        .where('idGestor', isEqualTo: gestor.id)
        .get();

    if (snap.docs.isEmpty) {
      return [];
    }

    return snap.docs.map((e) {
      CuidadorEntity cuidador = CuidadorEntity.fromMap(e.data());
      cuidador.id = e.id;
      return cuidador;
    }).toList();
  }
}
