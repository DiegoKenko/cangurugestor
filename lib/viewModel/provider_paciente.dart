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

  Future<void> update() async {
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

  Future<void> delete() async {
    FirestorePaciente().excluirPaciente(responsavel, _paciente);
    notifyListeners();
  }

  Future<void> loadMedicamentos() async {
    _paciente.medicamentos =
        await FirestoreMedicamento().todosMedicamentosPaciente(_paciente.id);
    notifyListeners();
  }

  Future<void> loadConsultas() async {
    _paciente.consultas =
        await FirestoreConsulta().todasConsultasPaciente(_paciente.id);
    notifyListeners();
  }

  Future<void> loadAtividades() async {
    _paciente.atividades =
        await FirestoreAtividade().todasAtividadesPaciente(_paciente.id);
    notifyListeners();
  }

  Future<void> addCuidadorPaciente(Cuidador cuidador) async {
    if (!cuidador.idPacientes.contains(_paciente.id)) {
      cuidador.idPacientes.add(_paciente.id);
      await FirestoreCuidador().update(cuidador);
      notifyListeners();
    }
  }

  Future<void> removeCuidadorPaciente(Cuidador cuidador) async {
    if (cuidador.idPacientes.contains(_paciente.id)) {
      cuidador.idPacientes.remove(_paciente.id);
      await FirestoreCuidador().update(cuidador);
      notifyListeners();
    }
  }
}
