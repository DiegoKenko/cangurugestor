import 'dart:math';

import 'package:cangurugestor/firebaseUtils/fire_cuidador.dart';
import 'package:cangurugestor/firebaseUtils/fire_login.dart';
import 'package:cangurugestor/firebaseUtils/fire_responsavel.dart';
import 'package:cangurugestor/model/cuidador.dart';
import 'package:cangurugestor/model/gestor.dart';
import 'package:cangurugestor/model/pessoa.dart';
import 'package:cangurugestor/model/responsavel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreGestor {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<Gestor> create(Pessoa pessoa) async {
    Gestor gestor = Gestor.fromPessoa(pessoa);
    DocumentReference<Map<String, dynamic>> doc =
        await firestore.collection('gestores').add(gestor.toMap());
    gestor.id = doc.id;

    FirestoreLogin().atualizaLoginGestor(gestor);

    return gestor;
  }

  Future<List<Responsavel>> todosClientesGestor(Gestor gestor) async {
    List<Responsavel> responsaveis = [];
    await firestore
        .collection('responsaveis')
        .where('idGestor', isEqualTo: gestor.id)
        .get()
        .then((value) {
      for (var element in value.docs) {
        Responsavel responsavel = Responsavel.fromMap(element.data());
        responsavel.id = element.id;
        responsaveis.add(responsavel);
      }
    });
    return responsaveis;
  }

  Future<List<Cuidador>> todosCuidadoresGestor(Gestor gestor) async {
    QuerySnapshot<Map<String, dynamic>> snap = await firestore
        .collection('cuidadores')
        .where('idGestor', isEqualTo: gestor.id)
        .get();

    if (snap.docs.isEmpty) {
      return [];
    }

    return snap.docs.map((e) {
      Cuidador cuidador = Cuidador.fromMap(e.data());
      cuidador.id = e.id;
      return cuidador;
    }).toList();
  }

  Future<Gestor> get(String id) async {
    var doc = await firestore.collection('gestores').doc(id).get();
    if (doc.data() != null) {
      Gestor gestor = Gestor.fromMap(doc.data()!);
      gestor.id = doc.id;
      return gestor;
    } else {
      return Gestor();
    }
  }

  Future<Gestor> update(Gestor gestor) async {
    await firestore
        .collection('gestores')
        .doc(gestor.id)
        .update(gestor.toMap());
    return gestor;
  }
}
