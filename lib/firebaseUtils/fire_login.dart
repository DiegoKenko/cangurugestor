import 'package:cangurugestor/model/cuidador.dart';
import 'package:cangurugestor/model/gestor.dart';
import 'package:cangurugestor/model/login_user.dart';
import 'package:cangurugestor/model/pessoa.dart';
import 'package:cangurugestor/model/responsavel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreLogin {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> atualizaLoginGestor(Gestor gestor) async {
    final LoginUser user = LoginUser.fromGestor(gestor);

    await firestore
        .collection('login')
        .where('doc', isEqualTo: user.doc)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        value.docs.first.reference.update(user.toMap());
      } else {
        firestore.collection('login').add(user.toMap());
      }
    });
  }

  Future<void> atualizaLoginResponsavel(Responsavel responsavel) async {
    final LoginUser user = LoginUser.fromResponsavel(responsavel);

    await firestore
        .collection('login')
        .where('doc', isEqualTo: user.doc)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        value.docs.first.reference.update(user.toMap());
      } else {
        firestore.collection('login').add(user.toMap());
      }
    });
  }

  Future<void> atualizaLoginCuidador(Cuidador cuidador) async {
    final LoginUser user = LoginUser.fromCuidador(cuidador);
    if (user.doc.isNotEmpty) {
      await firestore
          .collection('login')
          .where('doc', isEqualTo: user.doc)
          .get()
          .then((value) {
        if (value.docs.isNotEmpty) {
          value.docs.first.reference.update(user.toMap());
        } else {
          firestore.collection('login').add(user.toMap());
        }
      });
    }
  }

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

  Future<Pessoa> autenticarUsuarioEmail(String email) async {
    Pessoa user;
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
        return Pessoa();
      }
    } else {
      return Pessoa();
    }
  }
}
