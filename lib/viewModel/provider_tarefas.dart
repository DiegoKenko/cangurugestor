import 'package:cangurugestor/firebaseUtils/fire_tarefa.dart';
import 'package:cangurugestor/global.dart';
import 'package:cangurugestor/model/atividade.dart';
import 'package:cangurugestor/model/consulta.dart';
import 'package:cangurugestor/model/medicamento.dart';
import 'package:cangurugestor/model/paciente.dart';
import 'package:cangurugestor/model/tarefa.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class TarefasProvider extends ChangeNotifier {
  List<Tarefa> _tarefas = [];
  Paciente paciente = Paciente();
  EnumTarefa tipo = EnumTarefa.nenhuma;
  String idItem = '';

  List<Tarefa> get tarefas => _tarefas;

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
        idTipo: idItem,
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
        idTipo: idItem,
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
        tipo: EnumTarefa.consulta,
        idTipo: idItem,
      );
    } else {
      tarefa = Tarefa.init(
        dateTime: _tarefas.last.dateTime.add(
          const Duration(days: 7),
        ),
        nome: consulta.descricao,
        descricao: consulta.medico,
        observacao: consulta.observacao,
        tipo: EnumTarefa.consulta,
        idTipo: idItem,
      );
    }
    _addTarefa(tarefa);
  }

  void novaTarefaAtividade(Atividade atividade) {
    Tarefa tarefa = Tarefa();
    if (_tarefas.isEmpty) {
      tarefa = Tarefa.init(
        dateTime: DateTime.now(),
        nome: atividade.descricao,
        descricao: atividade.local,
        observacao: atividade.observacao,
        tipo: EnumTarefa.atividade,
        idTipo: idItem,
      );
    } else {
      tarefa = Tarefa.init(
        dateTime: _tarefas.last.dateTime.add(
          Duration(
            minutes: enumIntervaloEmMinutos(
                    atividade.frequenciaMedida, atividade.frequenciaQuantidade)
                .toInt(),
          ),
        ),
        nome: atividade.descricao,
        descricao: atividade.local,
        observacao: atividade.observacao,
        tipo: EnumTarefa.atividade,
        idTipo: idItem,
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
    paciente = Paciente();
    tipo = EnumTarefa.nenhuma;
    idItem = '';
    notifyListeners();
  }

  void load() async {
    if (paciente.id != '' && tipo != EnumTarefa.nenhuma && idItem.isNotEmpty) {
      _tarefas = await FirestoreTarefa()
          .todasTarefasItem(paciente, tipo.collection, idItem);
      notifyListeners();
    }
  }

  Future<void> delete(Tarefa tarefa) async {
    await FirestoreTarefa().delete(paciente.id, tarefa.id);
  }

  Future<void> loadTodasTarefas(EnumFiltroDataTarefa data) async {
    final DateTime now = DateTime.now();
    final DateFormat dateFormat = DateFormat('dd/MM/yyyy');
    if (paciente.id.isNotEmpty) {
      _tarefas = await FirestoreTarefa().todasTarefas(paciente);
    } else {
      _tarefas = [];
    }

    switch (data) {
      case EnumFiltroDataTarefa.ontem:
        _tarefas.removeWhere((t) =>
            t.date != dateFormat.format(now.subtract(const Duration(days: 1))));
        break;
      case EnumFiltroDataTarefa.hoje:
        _tarefas.removeWhere((t) => t.date != dateFormat.format(now));
        break;
      case EnumFiltroDataTarefa.amanha:
        _tarefas.removeWhere((t) =>
            t.date != dateFormat.format(now.add(const Duration(days: 1))));
        break;
      case EnumFiltroDataTarefa.estaSemana:
        _tarefas = _tarefas
            .where((t) => t.dateTime.isAfter(now.add(const Duration(days: 1))))
            .toList();
        _tarefas = _tarefas
            .where((t) => t.dateTime.isBefore(now.add(const Duration(days: 7))))
            .toList();
        break;
      default:
        _tarefas.removeWhere((t) => t.date != dateFormat.format(now));
    }

    _tarefas.sort((a, b) => a.date.compareTo(b.date));
    notifyListeners();
  }
}
