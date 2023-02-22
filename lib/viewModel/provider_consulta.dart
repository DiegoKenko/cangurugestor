import 'package:cangurugestor/firebaseUtils/fire_consulta.dart';
import 'package:cangurugestor/model/consulta.dart';
import 'package:flutter/cupertino.dart';

class ConsultaProvider extends ChangeNotifier {
  Consulta consulta = Consulta();

  void clear() {
    consulta = Consulta();
  }

  Future<void> load() async {
    var med = await FirestoreConsulta()
        .consultaPaciente(consulta.id, consulta.paciente.id);
    consulta = med;
    notifyListeners();
  }

  Future<void> delete() async {
    FirestoreConsulta()
        .excluirConsultaPaciente(consulta.id, consulta.paciente.id);
    notifyListeners();
  }

  Future<void> update() async {
    if (consulta.descricao.isEmpty) {
      return;
    }
    if (consulta.id.isNotEmpty) {
      FirestoreConsulta()
          .atualizarConsultaPaciente(consulta, consulta.paciente.id);
      notifyListeners();
    } else {
      Consulta consulta = await FirestoreConsulta()
          .novaConsultaPaciente(this.consulta, this.consulta.paciente.id);
      consulta = consulta;
      notifyListeners();
    }
  }
}
