import 'package:cangurugestor/model/gestor.dart';
import 'package:cangurugestor/model/login_user.dart';
import 'package:cangurugestor/view/componentes/animated_page_transition.dart';
import 'package:cangurugestor/view/telas/gest/gest_painel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirestoreLogin {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  atualizaLogin(LoginUser login) {
    firestore
        .collection('login')
        .where('doc', isEqualTo: login.doc)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        value.docs.first.reference.set(login.toMap());
      } else {
        firestore.collection('login').add(login.toMap());
      }
    });
  }

  deleteLogin(String doc) {
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

  Future<Gestor> autenticarUsuarioEmail(String email) async {
    Gestor gestor = Gestor();
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
        gestor = Gestor.fromMap(g.data()!);
        gestor.newId = g.id;
        return gestor;
      } else {
        return gestor;
      }
    } else {
      return gestor;
    }
  }
}
