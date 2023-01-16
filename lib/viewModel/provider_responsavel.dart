import 'package:cangurugestor/firebaseUtils/fire_responsavel.dart';
import 'package:cangurugestor/model/gestor.dart';
import 'package:cangurugestor/model/responsavel.dart';
import 'package:flutter/cupertino.dart';

class ResponsavelProvider extends ChangeNotifier {
  Responsavel responsavel = Responsavel();
  Gestor gestor = Gestor();
  ResponsavelProvider();

  void setResponsavel(Responsavel res) {
    responsavel = res;
    notifyListeners();
  }

  void setGestor(Gestor gest) {
    gestor = gest;
  }

  void update() {
    if (responsavel.id.isEmpty) {
      FirestoreResponsavel().incluirResponsavel(gestor, responsavel);
    } else {
      FirestoreResponsavel().atualizarResponavel(gestor, responsavel);
    }
    notifyListeners();
  }

  Future<void> loadPacientes() async {
    responsavel.pacientes =
        await FirestoreResponsavel().todosPacientesResponsavel(responsavel);
    notifyListeners();
  }
}
