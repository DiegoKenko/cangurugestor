import 'package:cangurugestor/classes/gestor.dart';
import 'package:cangurugestor/classes/login.dart';
import 'package:cangurugestor/ui/componentes/animated_page_transition.dart';
import 'package:cangurugestor/ui/telas/gest/gest_painel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class FirestoreLogin {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  atualizaLogin(Login login) {
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

  void autenticarUsuarioGoogle(BuildContext context, User user) {
    Gestor gestor = Gestor();
    firestore
        .collection('login')
        .where('googleEmail', isEqualTo: user.email)
        .get()
        .then(
          (snap) => {
            if (snap.docs.isNotEmpty)
              {
                if (snap.docs.first.data()['funcao'] == 'gestor')
                  {
                    firestore
                        .collection('gestores')
                        .doc(snap.docs.first.data()['doc'])
                        .get()
                        .then((value) {
                      gestor = Gestor.fromMap(value.data()!);
                      gestor.id = value.id;
                      Navigator.of(context).push(
                        AnimatedPageTransition(
                          page: PainelGestor(
                            gestor: gestor,
                          ),
                        ),
                      );
                    }),
                  }
              }
          },
          onError: (error, stackTrace) {},
        );
  }
}
