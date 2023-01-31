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
      if (atividade.descricao.isEmpty) {
        return;
      }
      FirestoreAtividade()
          .atualizarAtividadePaciente(atividade, atividade.paciente.id);
    } else {
      Atividade a = await FirestoreAtividade()
          .novaAtividadePaciente(atividade, atividade.paciente.id);
      atividade = a;
      notifyListeners();
    }
  }
}
