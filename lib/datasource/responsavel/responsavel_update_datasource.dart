import 'package:cangurugestor/global.dart';
import 'package:cangurugestor/model/responsavel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ResponsavelUpdateDatasource {
  Future<void> update(Responsavel responsavel) async {
    await getIt<FirebaseFirestore>()
        .collection('responsaveis')
        .doc(responsavel.id)
        .update(responsavel.toMap());
  }
}
