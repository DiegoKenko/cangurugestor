import 'package:cangurugestor/firebaseUtils/fire_cuidador.dart';
import 'package:cangurugestor/firebaseUtils/fire_gestor.dart';
import 'package:cangurugestor/firebaseUtils/fire_medicamento.dart';
import 'package:cangurugestor/firebaseUtils/fire_paciente.dart';
import 'package:cangurugestor/model/cuidador.dart';
import 'package:cangurugestor/model/paciente.dart';
import 'package:cangurugestor/model/responsavel.dart';
import 'package:flutter/cupertino.dart';

class PacienteProvider extends ChangeNotifier {
  Paciente paciente = Paciente();
  Responsavel responsavel = Responsavel();

  void setPaciente(Paciente paciente) {
    this.paciente = paciente;
    notifyListeners();
  }

  void setResponsavel(Responsavel responsavel) {
    this.responsavel = responsavel;
  }

  void clear() {
    paciente = Paciente();
    notifyListeners();
  }

  void update() async {
    if (paciente.id.isNotEmpty) {
      FirestorePaciente().atualizarPaciente(paciente);
      notifyListeners();
    } else {
      Paciente pac =
          await FirestorePaciente().incluirPaciente(responsavel, paciente);
      paciente = pac;
      notifyListeners();
    }
  }

  void delete() async {
    FirestorePaciente().excluirPaciente(responsavel, paciente);
    notifyListeners();
  }

  void load() async {
    paciente.medicamentos =
        await FirestoreMedicamento().todosMedicamentosPaciente(paciente.id);
    notifyListeners();
  }

  void addCuidadorPaciente(Cuidador cuidador) async {
    cuidador.idPacientes.add(paciente.id);
    await FirestoreCuidador().update(cuidador);
    notifyListeners();
  }
}
