import 'package:cangurugestor/firebaseUtils/fire_atividade.dart';
import 'package:cangurugestor/model/atividade.dart';
import 'package:flutter/material.dart';

class AtividadeProvider extends ChangeNotifier {
  Atividade atividade = Atividade();

  Future<void> delete() async {
    FirestoreAtividade()
        .excluirAtividadePaciente(atividade.id, atividade.paciente.id);
    notifyListeners();
  }

  void clear() {
    atividade = Atividade();
  }

  Future<void> update() async {
    if (atividade.descricao.isEmpty) {
      return;
    }
    if (atividade.id.isNotEmpty) {
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
