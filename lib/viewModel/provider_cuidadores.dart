import 'package:cangurugestor/model/cuidador.dart';
import 'package:cangurugestor/model/gestor.dart';
import 'package:cangurugestor/model/responsavel.dart';
import 'package:flutter/cupertino.dart';

class CuidadoresProvider extends ChangeNotifier {
  List<Cuidador> _cuidadores = [];
  Gestor _gestor = Gestor();
  List<Cuidador> get cuidadores => _cuidadores;
  Gestor get gestor => _gestor;

  set gestor(Gestor gestor) {
    _gestor = gestor;
    notifyListeners();
  }

  void add(Cuidador cuidador) {
    _cuidadores.add(cuidador);
    notifyListeners();
  }

  void delete(Cuidador cuidador) {
    _cuidadores.remove(cuidador);
    notifyListeners();
  }

  void update(Cuidador cuidador) {
    notifyListeners();
  }
}
