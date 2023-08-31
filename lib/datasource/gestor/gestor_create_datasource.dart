import 'package:cangurugestor/const/global.dart';
import 'package:cangurugestor/domain/entity/gestor_entity.dart';
import 'package:cangurugestor/domain/entity/pessoa_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GestorCreateDatasource {
  Future<GestorEntity> call(PessoaEntity pessoa) async {
    GestorEntity gestor = GestorEntity.fromPessoa(pessoa);
    DocumentReference<Map<String, dynamic>> doc =
        await getIt<FirebaseFirestore>()
            .collection('gestores')
            .add(gestor.toMap());
    gestor.id = doc.id;

    return gestor;
  }
}
