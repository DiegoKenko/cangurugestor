import 'package:cangurugestor/firebaseUtils/fire_gestor.dart';
import 'package:cangurugestor/model/cuidador.dart';
import 'package:cangurugestor/model/gestor.dart';
import 'package:cangurugestor/model/responsavel.dart';
import 'package:flutter/cupertino.dart';

class GestorProvider extends ChangeNotifier {
  Gestor gestor = Gestor();
  final FirestoreGestor _firestoreGestor = FirestoreGestor();
  List<Responsavel> _clientes = [];
  List<Cuidador> _cuidadores = [];
  List<Cuidador> _cuidadoresDisponiveis = [];

  List<Cuidador> get cuidadores => _cuidadores;
  List<Cuidador> get cuidadoresDisponiveis => _cuidadoresDisponiveis;
  List<Responsavel> get clientes => _clientes;

  set clientes(List<Responsavel> clientes) {
    _clientes = clientes;
    notifyListeners();
  }

  set cuidadores(List<Cuidador> cuidadores) {
    _cuidadores = cuidadores;
    notifyListeners();
  }

  Future<void> todosClientes() async {
    _clientes = await _firestoreGestor.todosClientesGestor(gestor);
    notifyListeners();
  }

  Future<void> todosCuidadores() async {
    _cuidadores = await _firestoreGestor.todosCuidadoresGestor(gestor);
    notifyListeners();
  }

  Future<void> todosCuidadoresDisponiveis() async {
    _cuidadoresDisponiveis =
        await _firestoreGestor.todosCuidadoresGestor(gestor);
    notifyListeners();
  }

  Future<void> addCuidadorGestor(Cuidador cuidador) async {
    if (!gestor.idCuidadores.contains(cuidador.id) && cuidador.id.isNotEmpty) {
      gestor.idCuidadores.add(cuidador.id);
      await _firestoreGestor.update(gestor);
    }
    notifyListeners();
  }

  void clear() {
    gestor = Gestor();
    _clientes = [];
    _cuidadores = [];
    _cuidadoresDisponiveis = [];
  }
}
