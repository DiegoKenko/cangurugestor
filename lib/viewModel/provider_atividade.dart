import 'package:cangurugestor/firebaseUtils/fire_atividade.dart';
import 'package:cangurugestor/model/atividade.dart';
import 'package:flutter/material.dart';

class AtividadeProvider extends ChangeNotifier {
  Atividade atividade = Atividade();

  void delete() async {
    FirestoreAtividade()
        .excluirAtividadePaciente(atividade.id, atividade.paciente.id);
    notifyListeners();
  }

  void clear() {
    atividade = Atividade();
  }

  void update() async {
    if (atividade.id.isNotEmpty) {
      FirestoreAtividade()
          .atualizarAtividadePaciente(atividade, atividade.paciente.id);
    } else {
      Atividade atividade = await FirestoreAtividade()
          .novaAtividadePaciente(this.atividade, this.atividade.paciente.id);
      atividade = atividade;
      notifyListeners();
    }
  }
}
