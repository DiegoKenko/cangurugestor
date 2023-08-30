import 'package:cangurugestor/const/global.dart';
import 'package:cangurugestor/domain/entity/responsavel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ResponsavelUpdateDatasource {
  Future<void> call(ResponsavelEntity responsavel) async {
    await getIt<FirebaseFirestore>()
        .collection('responsaveis')
        .doc(responsavel.id)
        .update(responsavel.toMap());
  }
}
