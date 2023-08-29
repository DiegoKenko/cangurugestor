import 'package:cangurugestor/global.dart';
import 'package:cangurugestor/model/cuidador.dart';
import 'package:cangurugestor/model/gestor.dart';
import 'package:cangurugestor/model/pessoa.dart';
import 'package:cangurugestor/model/responsavel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginAuntenticar {
  Future<Pessoa> autenticarUsuarioEmail(String email) async {
    Pessoa user;
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
        user = Gestor.fromMap(g.data()!);
        user.id = g.id;
        return user;
      } else if (x.docs.first.data()['funcao'] == 'cuidador') {
        DocumentSnapshot<Map<String, dynamic>> c =
            await getIt<FirebaseFirestore>()
                .collection('cuidadores')
                .doc(x.docs.first.data()['doc'])
                .get();
        user = Cuidador.fromMap(c.data()!);
        user.id = c.id;
        return user;
      } else if (x.docs.first.data()['funcao'] == 'responsavel') {
        DocumentSnapshot<Map<String, dynamic>> r =
            await getIt<FirebaseFirestore>()
                .collection('responsaveis')
                .doc(x.docs.first.data()['doc'])
                .get();
        user = Responsavel.fromMap(r.data()!);
        user.id = r.id;
        return user;
      } else {
        return Pessoa();
      }
    } else {
      return Pessoa();
    }
  }
}
