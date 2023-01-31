import 'package:cangurugestor/firebaseUtils/fire_responsavel.dart';
import 'package:cangurugestor/model/gestor.dart';
import 'package:cangurugestor/model/paciente.dart';
import 'package:cangurugestor/model/responsavel.dart';
import 'package:flutter/cupertino.dart';

class ResponsavelProvider extends ChangeNotifier {
  Responsavel responsavel = Responsavel();

  void setGestor(Gestor gest) {
    responsavel.gestor = gest;
  }

  void update() {
    if (responsavel.id.isEmpty) {
      FirestoreResponsavel().incluirResponsavel(responsavel);
    } else {
      FirestoreResponsavel().atualizarResponavel(responsavel);
    }
    notifyListeners();
  }

  Future<void> loadPacientes() async {
    responsavel.pacientes =
        await FirestoreResponsavel().todosPacientesResponsavel(responsavel);
    notifyListeners();
  }

  Future<void> delete(Gestor gestor, Responsavel responsavel) async {
    FirestoreResponsavel().excluirResponsavel(gestor, responsavel);
    notifyListeners();
  }

  void clear() {
    responsavel = Responsavel();
  }

  void addPaciente(Paciente paciente) {
    if (responsavel.idPacientes.contains(paciente.id)) {
      return;
    }
    responsavel.idPacientes.add(paciente.id);
    update();
  }
}
