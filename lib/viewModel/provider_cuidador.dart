import 'package:cangurugestor/firebaseUtils/fire_cuidador.dart';
import 'package:cangurugestor/firebaseUtils/fire_gestor.dart';
import 'package:cangurugestor/firebaseUtils/fire_login.dart';
import 'package:cangurugestor/model/cuidador.dart';
import 'package:cangurugestor/model/gestor.dart';
import 'package:cangurugestor/model/paciente.dart';
import 'package:flutter/cupertino.dart';

class CuidadorProvider extends ChangeNotifier {
  Cuidador cuidador = Cuidador();
  List<Paciente> _pacientes = [];
  Gestor _gestor = Gestor();

  set gestor(Gestor gestor) {
    _gestor = gestor;
  }

  List<Paciente> get pacientes => _pacientes;

  Future<void> update() async {
    if (cuidador.id.isEmpty) {
      cuidador = await FirestoreCuidador().create(cuidador);
    } else {
      await FirestoreCuidador().update(cuidador);
    }
    await FirestoreLogin().atualizaLoginCuidador(cuidador);
    notifyListeners();
  }

  Future<void> delete() async {
    //await FirestoreCuidador().delete(_cuidador);
    _gestor.idCuidadores.remove(cuidador.id);
    await FirestoreGestor().update(_gestor);
    notifyListeners();
  }

  void clear() {
    cuidador = Cuidador();
    notifyListeners();
  }

  void todosPacientes() async {
    _pacientes = await FirestoreCuidador().todosPacientesCuidador(cuidador);
    notifyListeners();
  }
}
