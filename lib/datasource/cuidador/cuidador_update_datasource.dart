import 'package:cangurugestor/const/global.dart';
import 'package:cangurugestor/domain/entity/cuidador_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CuidadorUpdateDatasource {
  Future<CuidadorEntity> call(CuidadorEntity cuidador) async {
    await getIt<FirebaseFirestore>()
        .collection('cuidadores')
        .doc(cuidador.id)
        .update(cuidador.toMap());
    return cuidador;
  }
}
