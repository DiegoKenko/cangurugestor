import 'package:cangurugestor/const/global.dart';
import 'package:cangurugestor/domain/entity/responsavel_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ResponsavelCreateDatasource {
  Future<ResponsavelEntity> call(ResponsavelEntity responsavel) async {
    var doc = await getIt<FirebaseFirestore>()
        .collection('responsaveis')
        .add(responsavel.toMap());
    responsavel.id = doc.id;
    return responsavel;
  }
}
