import 'package:cangurugestor/firebaseUtils/fire_gestor.dart';
import 'package:cangurugestor/model/cuidador.dart';
import 'package:cangurugestor/model/gestor.dart';
import 'package:cangurugestor/model/responsavel.dart';
import 'package:flutter/cupertino.dart';

class GestorProvider extends ChangeNotifier {
  Gestor _gestor = Gestor();
  final FirestoreGestor _firestoreGestor = FirestoreGestor();
  List<Responsavel> _clientes = [];
  List<Cuidador> _cuidadores = [];

  List<Cuidador> get cuidadores => _cuidadores;
  List<Responsavel> get clientes => _clientes;
  Gestor get gestor => _gestor;

  set clientes(List<Responsavel> clientes) {
    _clientes = clientes;
    notifyListeners();
  }

  set cuidadores(List<Cuidador> cuidadores) {
    _cuidadores = cuidadores;
    notifyListeners();
  }

  set gestor(Gestor gestor) {
    _gestor = gestor;
    notifyListeners();
  }

  void todosClientes() async {
    _clientes = await _firestoreGestor.todosClientesGestor(_gestor);
    notifyListeners();
  }

  void todosCuidadores() async {
    _cuidadores = await _firestoreGestor.todosCuidadoresGestor(_gestor);
    notifyListeners();
  }
}
