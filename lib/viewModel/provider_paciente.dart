import 'package:cangurugestor/firebaseUtils/fire_atividade.dart';
import 'package:cangurugestor/firebaseUtils/fire_consulta.dart';
import 'package:cangurugestor/firebaseUtils/fire_cuidador.dart';
import 'package:cangurugestor/firebaseUtils/fire_medicamento.dart';
import 'package:cangurugestor/firebaseUtils/fire_paciente.dart';
import 'package:cangurugestor/model/cuidador.dart';
import 'package:cangurugestor/model/paciente.dart';
import 'package:cangurugestor/model/responsavel.dart';
import 'package:flutter/widgets.dart';


class PacienteProvider extends ChangeNotifier {
  Paciente _paciente = Paciente();
  Responsavel responsavel = Responsavel();
  List<Cuidador> _cuidadores = [];

  List<Cuidador> get cuidadores => _cuidadores;
  Paciente get paciente => _paciente;

  set paciente(Paciente paciente) {
    _paciente = paciente;
    notifyListeners();
  }

  void clear() {
    paciente = Paciente();
    responsavel = Responsavel();
    _cuidadores = [];
  }

  Future<void> update() async {
    if (_paciente.id.isNotEmpty) {
      await FirestorePaciente().atualizarPaciente(_paciente);
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
    if (!paciente.idCuidadores.contains(cuidador.id)) {
      cuidador.idPacientes.add(_paciente.id);
      paciente.idCuidadores.add(cuidador.id);
      await FirestoreCuidador().update(cuidador);
      await update();
      notifyListeners();
    }
  }

  Future<void> removeCuidadorPaciente(Cuidador cuidador) async {
    if (paciente.idCuidadores.contains(cuidador.id)) {
      cuidador.idPacientes.remove(_paciente.id);
      paciente.idCuidadores.remove(cuidador.id);
      await FirestoreCuidador().update(cuidador);
      await update();
      notifyListeners();
    }
  }

  Future<void> loadCuidadores() async {
    _cuidadores = await FirestorePaciente().todosCuidadoresPaciente(_paciente);
    notifyListeners();
  }
}
