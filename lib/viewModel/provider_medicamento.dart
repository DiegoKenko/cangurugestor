import 'package:cangurugestor/firebaseUtils/fire_medicamento.dart';
import 'package:cangurugestor/model/medicamento.dart';
import 'package:cangurugestor/model/paciente.dart';
import 'package:flutter/cupertino.dart';

class MedicamentoProvider extends ChangeNotifier {
  Medicamento medicamento = Medicamento();
  Paciente paciente = Paciente();

  void setMedicamento(Medicamento medicamento) {
    this.medicamento = medicamento;
  }

  void setPaciente(Paciente paciente) {
    this.paciente = paciente;
  }

  void clear() {
    medicamento = Medicamento();
    paciente = Paciente();
  }

  Future<void> load() async {
    var med = await FirestoreMedicamento()
        .medicamentoPaciente(medicamento.id, paciente.id);
    setMedicamento(med);
    notifyListeners();
  }

  Future<void> delete() async {
    FirestoreMedicamento()
        .excluirMedicamentoPaciente(medicamento.id, paciente.id);
    notifyListeners();
  }

  Future<void> update() async {
    if (medicamento.id.isNotEmpty) {
      if (medicamento.nome.isEmpty) {
        return;
      }
      FirestoreMedicamento()
          .atualizarMedicamentoPaciente(medicamento, paciente.id);
      notifyListeners();
    } else {
      Medicamento med = await FirestoreMedicamento()
          .novoMedicamentoPaciente(medicamento, paciente.id);
      medicamento = med;
      notifyListeners();
    }
  }
}
