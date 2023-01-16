import 'package:cangurugestor/firebaseUtils/fire_gestor.dart';
import 'package:cangurugestor/model/gestor.dart';
import 'package:cangurugestor/model/responsavel.dart';
import 'package:flutter/cupertino.dart';

class GestorProvider extends ChangeNotifier {
  Gestor _gestor = Gestor();
  final FirestoreGestor _firestoreGestor = FirestoreGestor();
  List<Responsavel> _clientes = [];

  get gestor => _gestor;
  List<Responsavel> get clientes => _clientes;

  setGestor(Gestor gestor) {
    _gestor = gestor;
    notifyListeners();
  }

  void todosClientes() async {
    _clientes = await _firestoreGestor.todosClientesGestor(_gestor);
    notifyListeners();
  }
}
