import 'package:cangurugestor/global.dart';
import 'package:cangurugestor/model/cuidador.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class CuidadorCreateDatasource {
  Future<Cuidador> call(Cuidador cuidador) async {
    var doc = await getIt<FirebaseFirestore>()
        .collection('cuidadores')
        .add(cuidador.toMap());
    cuidador.id = doc.id;

    return cuidador;
  }
}
