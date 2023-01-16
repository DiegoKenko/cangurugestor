import 'package:cangurugestor/firebaseUtils/fire_gestor.dart';
import 'package:cangurugestor/model/gestor.dart';
import 'package:cangurugestor/model/responsavel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class GestorProvider extends ChangeNotifier {
  Gestor _gestor = Gestor();
  FirestoreGestor _firestoreGestor = FirestoreGestor();
  List<Responsavel> _costumers = [];

  get gestor => _gestor;
  List<Responsavel> get costumers => _costumers;

  setGestor(Gestor gestor) {
    _gestor = gestor;
    notifyListeners();
  }

  void allCostumers() async {
    _costumers = await _firestoreGestor.todosClientesGestor(_gestor);
    notifyListeners();
  }
}
