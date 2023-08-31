import 'package:cangurugestor/const/global.dart';
import 'package:cangurugestor/domain/entity/responsavel_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ResponsavelDeleteDatasource {
  Future<void> call(ResponsavelEntity responsavel) async {
    await getIt<FirebaseFirestore>()
        .collection('responsaveis')
        .doc(responsavel.id)
        .delete();
  }
}
