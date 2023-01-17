import 'package:cangurugestor/firebaseUtils/fire_tarefa.dart';
import 'package:cangurugestor/global.dart';
import 'package:cangurugestor/model/paciente.dart';
import 'package:cangurugestor/model/tarefa.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';

class TarefasProvider extends ChangeNotifier {
  List<Tarefa> _tarefas = [];
  Paciente _paciente = Paciente();
  EnumTarefa _tipo = EnumTarefa.nenhuma;
  String _idItem = '';

  void addTarefa(Tarefa tarefa) {
    _tarefas.add(tarefa);
    notifyListeners();
  }

  void removeTarefa(Tarefa tarefa) {
    _tarefas.remove(tarefa);
    notifyListeners();
  }

  void setPaciente(Paciente paciente) {
    _paciente = paciente;
    notifyListeners();
  }

  set tipo(EnumTarefa tipo) {
    _tipo = tipo;
    notifyListeners();
  }

  set idItem(String idItem) {
    _idItem = idItem;
    notifyListeners();
  }

  void clear() {
    _tarefas.clear();
    _paciente = Paciente();
    _tipo = EnumTarefa.nenhuma;
    _idItem = '';
    notifyListeners();
  }

  void load() async {
    if (_paciente.id != '' &&
        _tipo != EnumTarefa.nenhuma &&
        _idItem.isNotEmpty) {
      _tarefas = await FirestoreTarefa()
          .todasTarefasItem(_paciente, _tipo.collection, _idItem);

      notifyListeners();
    }
  }
}
