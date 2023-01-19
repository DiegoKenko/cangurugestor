import 'package:cangurugestor/firebaseUtils/fire_cuidador.dart';
import 'package:cangurugestor/firebaseUtils/fire_gestor.dart';
import 'package:cangurugestor/model/cuidador.dart';
import 'package:cangurugestor/model/gestor.dart';
import 'package:flutter/cupertino.dart';

class CuidadorProvider extends ChangeNotifier {
  Cuidador _cuidador = Cuidador();
  Gestor _gestor = Gestor();

  set gestor(Gestor gestor) {
    _gestor = gestor;
  }

  set cuidador(Cuidador cuidador) {
    _cuidador = cuidador;
  }

  Cuidador get cuidador => _cuidador;

  void addCuidadorGestor() {
    if (!_gestor.idCuidadores.contains(_cuidador.id)) {
      _gestor.idCuidadores.add(_cuidador.id);
    }
  }

  Future<void> update() async {
    if (cuidador.id.isEmpty) {
      _cuidador = await FirestoreCuidador().create(_cuidador);
    } else {
      await FirestoreCuidador().update(_cuidador);
    }
    addCuidadorGestor();
    await FirestoreGestor().update(_gestor);
    notifyListeners();
  }

  Future<void> delete() async {
    //await FirestoreCuidador().delete(_cuidador);
    _gestor.idCuidadores.remove(_cuidador.id);
    await FirestoreGestor().update(_gestor);
    notifyListeners();
  }

  void clear() {
    _cuidador = Cuidador();
    notifyListeners();
  }
}
