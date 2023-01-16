import 'package:cangurugestor/model/atividade.dart';
import 'package:flutter/material.dart';

class AtividadeProvider extends ChangeNotifier {
  Atividade atividade = Atividade();

  setAtividade(Atividade atividade) {
    this.atividade = atividade;
    notifyListeners();
  }
}
