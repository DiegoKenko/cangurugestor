import 'package:cangurugestor/model/cuidador.dart';
import 'package:cangurugestor/model/gestor.dart';
import 'package:cangurugestor/model/login_user.dart';
import 'package:cangurugestor/model/responsavel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreLogin {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  void atualizaLogin(LoginUser login) {}

  void deleteLogin(String doc) {
    firestore
        .collection('login')
        .where('doc', isEqualTo: doc)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        value.docs.first.reference.delete();
      }
    });
  }

  Future<LoginUser> autenticarUsuarioEmail(String email) async {
    LoginUser user;
    QuerySnapshot<Map<String, dynamic>> x = await firestore
        .collection('login')
        .where('email', isEqualTo: email)
        .get();
    if (x.docs.isNotEmpty) {
      if (x.docs.first.data()['funcao'] == 'gestor') {
        DocumentSnapshot<Map<String, dynamic>> g = await firestore
            .collection('gestores')
            .doc(x.docs.first.data()['doc'])
            .get();
        user = Gestor.fromMap(g.data()!);
        user.id = g.id;
        return user;
      } else if (x.docs.first.data()['funcao'] == 'cuidador') {
        DocumentSnapshot<Map<String, dynamic>> c = await firestore
            .collection('cuidadores')
            .doc(x.docs.first.data()['doc'])
            .get();
        user = Cuidador.fromMap(c.data()!);
        user.id = c.id;
        return user;
      } else if (x.docs.first.data()['funcao'] == 'responsavel') {
        DocumentSnapshot<Map<String, dynamic>> r = await firestore
            .collection('responsaveis')
            .doc(x.docs.first.data()['doc'])
            .get();
        user = Responsavel.fromMap(r.data()!);
        user.id = r.id;
        return user;
      } else {
        return LoginUser();
      }
    } else {
      return LoginUser();
    }
  }
}
