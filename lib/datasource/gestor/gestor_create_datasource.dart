import 'package:cangurugestor/const/global.dart';
import 'package:cangurugestor/domain/entity/default_error_entity.dart';
import 'package:cangurugestor/domain/entity/gestor_entity.dart';
import 'package:cangurugestor/domain/entity/pessoa_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:result_dart/result_dart.dart';

class GestorCreateDatasource {
  Future<Result<GestorEntity, DefaultErrorEntity>> call(
    PessoaEntity pessoa,
  ) async {
    try {
      GestorEntity gestor = GestorEntity.fromPessoa(pessoa);
      DocumentReference<Map<String, dynamic>> doc =
          await getIt<FirebaseFirestore>()
              .collection('gestores')
              .add(gestor.toMap());
      gestor.id = doc.id;

      return gestor.toSuccess();
    } catch (e) {
      return Failure(DefaultErrorEntity('message'));
    }
  }
}
