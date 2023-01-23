import 'package:cangurugestor/firebaseUtils/fire_tarefa.dart';
import 'package:cangurugestor/global.dart';
import 'package:cangurugestor/model/consulta.dart';
import 'package:cangurugestor/model/medicamento.dart';
import 'package:cangurugestor/model/paciente.dart';
import 'package:cangurugestor/model/tarefa.dart';
import 'package:flutter/cupertino.dart';

class TarefasProvider extends ChangeNotifier {
  List<Tarefa> _tarefas = [];
  Paciente _paciente = Paciente();
  EnumTarefa _tipo = EnumTarefa.nenhuma;
  String _idItem = '';

  List<Tarefa> get tarefas => _tarefas;
  Paciente get paciente => _paciente;
  EnumTarefa get tipo => _tipo;
  String get idItem => _idItem;

  set paciente(Paciente paciente) {
    _paciente = paciente;
  }

  set tipo(EnumTarefa tipo) {
    _tipo = tipo;
  }

  set idItem(String id) {
    _idItem = id;
  }

  void _addTarefa(Tarefa tarefa) async {
    await FirestoreTarefa().insert(paciente, tarefa);
  }

  void updateTarefa(Tarefa tarefa) {
    FirestoreTarefa().update(paciente, tarefa);
    notifyListeners();
  }

  void novaTarefaMedicamento(Medicamento medicamento) {
    Tarefa tarefa = Tarefa();
    if (_tarefas.isEmpty) {
      tarefa = Tarefa.init(
        dateTime: DateTime.now(),
        nome: medicamento.nome,
        descricao: medicamento.descricao,
        observacao: medicamento.observacao,
        tipo: EnumTarefa.medicamento,
        idTipo: _idItem,
      );
    } else {
      tarefa = Tarefa.init(
        dateTime: _tarefas.last.dateTime.add(
          Duration(
            minutes: enumIntervaloEmMinutos(
                    medicamento.intervalo, medicamento.intervaloQuantidade)
                .toInt(),
          ),
        ),
        nome: medicamento.nome,
        descricao: medicamento.descricao,
        observacao: medicamento.observacao,
        tipo: EnumTarefa.medicamento,
        idTipo: _idItem,
      );
    }
    _addTarefa(tarefa);
  }

  void novaTarefaConsulta(Consulta consulta) {
    Tarefa tarefa = Tarefa();
    if (_tarefas.isEmpty) {
      tarefa = Tarefa.init(
        dateTime: DateTime.now(),
        nome: consulta.descricao,
        descricao: consulta.medico,
        observacao: consulta.observacao,
        tipo: EnumTarefa.medicamento,
        idTipo: _idItem,
      );
    } else {
      tarefa = Tarefa.init(
        dateTime: _tarefas.last.dateTime.add(
          Duration(days: 7),
        ),
        nome: consulta.descricao,
        descricao: consulta.medico,
        observacao: consulta.observacao,
        tipo: EnumTarefa.medicamento,
        idTipo: _idItem,
      );
    }
    _addTarefa(tarefa);
  }

  void removeTarefa(Tarefa tarefa) {
    _tarefas.remove(tarefa);
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
