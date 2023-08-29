import 'package:cangurugestor/global.dart';
import 'package:cangurugestor/model/responsavel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReponsavelCreateDatasource {
  Future<Responsavel> create(Responsavel responsavel) async {
    var doc = await getIt<FirebaseFirestore>()
        .collection('responsaveis')
        .add(responsavel.toMap());
    responsavel.id = doc.id;
    return responsavel;
  }
}
