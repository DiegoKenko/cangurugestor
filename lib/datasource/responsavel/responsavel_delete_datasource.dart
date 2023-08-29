import 'package:cangurugestor/global.dart';
import 'package:cangurugestor/model/responsavel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ResponsavelDelteDatasource {
  Future<void> delete(Responsavel responsavel) async {
    await getIt<FirebaseFirestore>()
        .collection('responsaveis')
        .doc(responsavel.id)
        .delete();
  }
}
