import 'package:cangurugestor/const/global.dart';
import 'package:cangurugestor/domain/entity/cuidador_entity.dart';
import 'package:cangurugestor/domain/entity/default_error_entity.dart';
import 'package:cangurugestor/domain/entity/pessoa_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:result_dart/result_dart.dart';

class CuidadorCreateDatasource {
  Future<Result<CuidadorEntity, DefaultErrorEntity>> call(
    PessoaEntity pessoa,
  ) async {
    try {
      CuidadorEntity cuidador = CuidadorEntity.fromPessoa(pessoa);
      DocumentReference<Map<String, dynamic>> doc =
          await getIt<FirebaseFirestore>()
              .collection('cuidadores')
              .add(cuidador.toMap());
      cuidador.id = doc.id;

      return cuidador.toSuccess();
    } catch (e) {
      return Failure(DefaultErrorEntity('message'));
    }
  }
}
