import 'package:cangurugestor/firebaseUtils/fire_responsavel.dart';
import 'package:cangurugestor/model/paciente.dart';
import 'package:cangurugestor/model/responsavel.dart';
import 'package:flutter/cupertino.dart';

class ResponsavelProvider extends ChangeNotifier {
  Responsavel responsavel = Responsavel();
  ResponsavelProvider();

  void setResponsavel(Responsavel res) {
    responsavel = res;
    notifyListeners();
  }

  Future<void> loadPacientes() async {
    responsavel.pacientes =
        await FirestoreResponsavel().todosPacientesResponsavel(responsavel);
    notifyListeners();
  }
}
