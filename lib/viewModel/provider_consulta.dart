import 'package:cangurugestor/firebaseUtils/fire_consulta.dart';
import 'package:cangurugestor/model/consulta.dart';
import 'package:cangurugestor/model/paciente.dart';
import 'package:flutter/cupertino.dart';

class ConsultaProvider extends ChangeNotifier {
  Consulta _consulta = Consulta();
  Paciente _paciente = Paciente();

  Consulta get consulta => _consulta;
  Paciente get paciente => _paciente;

  set consulta(Consulta consulta) {
    _consulta = _consulta;
  }

  set paciente(Paciente paciente) {
    _paciente = _paciente;
  }

  void clear() {
    _consulta = Consulta();
    _paciente = Paciente();
    notifyListeners();
  }

  Future<void> load() async {
    var med =
        await FirestoreConsulta().consultaPaciente(_consulta.id, _paciente.id);
    consulta = med;
    notifyListeners();
  }

  Future<void> update() async {
    if (_consulta.id.isNotEmpty) {
      FirestoreConsulta().atualizarConsultaPaciente(_consulta, _paciente.id);
      notifyListeners();
    } else {
      Consulta med = await FirestoreConsulta()
          .novaConsultaPaciente(_consulta, _paciente.id);
      _consulta = med;
      notifyListeners();
    }
  }
}
