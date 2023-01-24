import 'package:cangurugestor/firebaseUtils/fire_atividade.dart';
import 'package:cangurugestor/firebaseUtils/fire_consulta.dart';
import 'package:cangurugestor/firebaseUtils/fire_cuidador.dart';
import 'package:cangurugestor/firebaseUtils/fire_medicamento.dart';
import 'package:cangurugestor/firebaseUtils/fire_paciente.dart';
import 'package:cangurugestor/model/cuidador.dart';
import 'package:cangurugestor/model/paciente.dart';
import 'package:cangurugestor/model/responsavel.dart';
import 'package:flutter/cupertino.dart';

class PacienteProvider extends ChangeNotifier {
  Paciente _paciente = Paciente();
  Responsavel responsavel = Responsavel();

  Paciente get paciente => _paciente;

  set paciente(Paciente paciente) {
    _paciente = paciente;
    notifyListeners();
  }

  void clear() {
    paciente = Paciente();
    notifyListeners();
  }

  void update() async {
    if (_paciente.id.isNotEmpty) {
      FirestorePaciente().atualizarPaciente(_paciente);
      notifyListeners();
    } else {
      Paciente pac =
          await FirestorePaciente().incluirPaciente(responsavel, _paciente);
      paciente = pac;
      notifyListeners();
    }
  }

  void delete() async {
    FirestorePaciente().excluirPaciente(responsavel, _paciente);
    notifyListeners();
  }

  void loadMedicamentos() async {
    _paciente.medicamentos =
        await FirestoreMedicamento().todosMedicamentosPaciente(_paciente.id);
    notifyListeners();
  }

  void loadConsultas() async {
    _paciente.consultas =
        await FirestoreConsulta().todasConsultasPaciente(_paciente.id);
    notifyListeners();
  }

  void loadAtividades() async {
    _paciente.atividades =
        await FirestoreAtividade().todasAtividadesPaciente(_paciente.id);
    notifyListeners();
  }

  void addCuidadorPaciente(Cuidador cuidador) async {
    cuidador.idPacientes.add(_paciente.id);
    await FirestoreCuidador().update(cuidador);
    notifyListeners();
  }
}
