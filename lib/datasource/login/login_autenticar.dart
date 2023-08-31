import 'package:cangurugestor/const/global.dart';
import 'package:cangurugestor/domain/entity/cuidador_entity.dart';
import 'package:cangurugestor/domain/entity/gestor_entity.dart';
import 'package:cangurugestor/domain/entity/pessoa_entity.dart';
import 'package:cangurugestor/domain/entity/responsavel_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginAuntenticarDatasource {
  Future<PessoaEntity> call(String email) async {
    PessoaEntity user;
    QuerySnapshot<Map<String, dynamic>> x = await getIt<FirebaseFirestore>()
        .collection('login')
        .where('email', isEqualTo: email)
        .get();
    if (x.docs.isNotEmpty) {
      if (x.docs.first.data()['funcao'] == 'gestor') {
        DocumentSnapshot<Map<String, dynamic>> g =
            await getIt<FirebaseFirestore>()
                .collection('gestores')
                .doc(x.docs.first.data()['doc'])
                .get();
        user = GestorEntity.fromMap(g.data()!);
        user.id = g.id;
        return user;
      } else if (x.docs.first.data()['funcao'] == 'cuidador') {
        DocumentSnapshot<Map<String, dynamic>> c =
            await getIt<FirebaseFirestore>()
                .collection('cuidadores')
                .doc(x.docs.first.data()['doc'])
                .get();
        user = CuidadorEntity.fromMap(c.data()!);
        user.id = c.id;
        return user;
      } else if (x.docs.first.data()['funcao'] == 'responsavel') {
        DocumentSnapshot<Map<String, dynamic>> r =
            await getIt<FirebaseFirestore>()
                .collection('responsaveis')
                .doc(x.docs.first.data()['doc'])
                .get();
        user = ResponsavelEntity.fromMap(r.data()!);
        user.id = r.id;
        return user;
      } else {
        return PessoaEntity();
      }
    } else {
      return PessoaEntity();
    }
  }
}
