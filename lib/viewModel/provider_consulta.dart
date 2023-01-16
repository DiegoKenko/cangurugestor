import 'package:cangurugestor/firebaseUtils/fire_consulta.dart';
import 'package:cangurugestor/model/consulta.dart';
import 'package:cangurugestor/model/paciente.dart';
import 'package:flutter/cupertino.dart';

class ConsultaProvider extends ChangeNotifier {
  Consulta consulta = Consulta();
  Paciente paciente = Paciente();

  void setConsulta(Consulta consulta) {
    this.consulta = consulta;
  }

  void setPaciente(Paciente paciente) {
    this.paciente = paciente;
  }

  void clear() {
    consulta = Consulta();
    paciente = Paciente();
    notifyListeners();
  }

  Future<void> load() async {
    var med =
        await FirestoreConsulta().consultaPaciente(consulta.id, paciente.id);
    setConsulta(med);
    notifyListeners();
  }

  Future<void> update() async {
    if (consulta.id.isNotEmpty) {
      FirestoreConsulta().atualizarConsultaPaciente(consulta, paciente.id);
      notifyListeners();
    } else {
      Consulta med =
          await FirestoreConsulta().novaConsultaPaciente(consulta, paciente.id);
      consulta = med;
      notifyListeners();
    }
  }
}
