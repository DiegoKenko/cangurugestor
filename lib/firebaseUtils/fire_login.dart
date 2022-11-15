import 'package:cangurugestor/classes/gestor.dart';
import 'package:cangurugestor/classes/login.dart';
import 'package:cangurugestor/classes/responsavel.dart';
import 'package:cangurugestor/ui/telas/gest/gest_painel.dart';
import 'package:cangurugestor/utils/create_animated_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:cangurugestor/global.dart' as global;

class FirestoreLogin {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  atualizaLogin(Login login) {
    FirebaseFirestore.instance
        .collection('login')
        .where('doc', isEqualTo: login.doc)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        value.docs.first.reference.set(login.toMap());
      } else {
        FirebaseFirestore.instance.collection('login').add(login.toMap());
      }
    });
  }

  deleteLogin(String doc) {
    FirebaseFirestore.instance
        .collection('login')
        .where('doc', isEqualTo: doc)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        value.docs.first.reference.delete();
      }
    });
  }

  autenticarUsuarioGoogle(BuildContext context, User user) async {
    Gestor gestor = Gestor();
    await FirebaseFirestore.instance
        .collection('login')
        .where('googleEmail', isEqualTo: user.email)
        .get()
        .then(
          (snap) => {
            if (snap.docs.isNotEmpty)
              {
                if (snap.docs.first.data()['funcao'] == 'gestor')
                  {
                    // Grava gestor atual
                    global.idGestorGlobal = snap.docs.first.id,
                    FirebaseFirestore.instance
                        .collection('gestores')
                        .doc(snap.docs.first.data()['doc'])
                        .get()
                        .then((value) {
                      gestor = Gestor.fromMap(value.data()!);
                    }),
                    // Busca todos os clientes
                    FirebaseFirestore.instance
                        .collection('responsaveis')
                        .where('gestor', isEqualTo: global.idGestorGlobal)
                        .get()
                        .then(
                      (value) {
                        List<Responsavel> responsaveis = [];
                        for (var doc in value.docs) {
                          responsaveis.add(
                            Responsavel.fromMap(
                              doc.data(),
                            ),
                          );
                          responsaveis.last.setId(doc.id);
                        }
                        responsaveis.sort(
                          (a, b) => a.nome.toUpperCase().compareTo(
                                b.nome.toUpperCase(),
                              ),
                        );
                        gestor.todosClientes(responsaveis);
                        // Painel gestor
                        Navigator.pushReplacement(
                          context,
                          MyRoute().createRoute(
                            PainelGestor(gestor: gestor),
                          ),
                        );
                      },
                    ),
                  }
                else
                  {}
              }
          },
          onError: (error, stackTrace) {},
        );
  }
}
