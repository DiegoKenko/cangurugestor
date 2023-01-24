import 'package:cangurugestor/firebaseUtils/fire_gestor.dart';
import 'package:cangurugestor/model/cuidador.dart';
import 'package:cangurugestor/model/gestor.dart';
import 'package:cangurugestor/model/paciente.dart';
import 'package:cangurugestor/model/responsavel.dart';
import 'package:flutter/cupertino.dart';

class GestorProvider extends ChangeNotifier {
  Gestor _gestor = Gestor();
  final FirestoreGestor _firestoreGestor = FirestoreGestor();
  List<Responsavel> _clientes = [];
  List<Cuidador> _cuidadores = [];
  List<Cuidador> _cuidadoresDisponiveisPaciente = [];

  List<Cuidador> get cuidadores => _cuidadores;
  List<Responsavel> get clientes => _clientes;
  Gestor get gestor => _gestor;
  List<Cuidador> get cuidadoresDisponiveisPaciente =>
      _cuidadoresDisponiveisPaciente;

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

  Future<void> todosCuidadoresPaciente(Paciente paciente) async {
    _cuidadores =
        await _firestoreGestor.todosCuidadoresPaciente(gestor, paciente.id);
    notifyListeners();
  }

  void todosCuidadores() async {
    _cuidadores = await _firestoreGestor.todosCuidadoresGestor(_gestor);
    notifyListeners();
  }

  void todosCuidadoresDisponiveis(Paciente paciente) async {
    List<Cuidador> cuidadores =
        await _firestoreGestor.todosCuidadoresGestor(_gestor);
    List<Cuidador> cuidadoresDisponiveis =
        await _firestoreGestor.todosCuidadoresPaciente(_gestor, paciente.id);

    _cuidadoresDisponiveisPaciente = cuidadores
        .where((element) =>
            !cuidadoresDisponiveis.any((cuidador) => cuidador.id == element.id))
        .toList();
    notifyListeners();
  }
}
