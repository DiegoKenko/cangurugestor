import 'package:cangurugestor/const/global.dart';
import 'package:cangurugestor/domain/entity/cuidador_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CuidadorCreateDatasource {
  Future<CuidadorEntity> call(CuidadorEntity cuidador) async {
    var doc = await getIt<FirebaseFirestore>()
        .collection('cuidadores')
        .add(cuidador.toMap());
    cuidador.id = doc.id;

    return cuidador;
  }
}
