import 'package:cangurugestor/firebaseUtils/fire_tarefa.dart';
import 'package:cangurugestor/global.dart';
import 'package:cangurugestor/model/atividade.dart';
import 'package:cangurugestor/model/consulta.dart';
import 'package:cangurugestor/model/medicamento.dart';
import 'package:cangurugestor/model/paciente.dart';
import 'package:cangurugestor/model/tarefa.dart';
import 'package:flutter/cupertino.dart';

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
    if (paciente.id.isNotEmpty) {
      _tarefas = await FirestoreTarefa().todasTarefasPeriodo(paciente, data);
    }

    _tarefas.sort((a, b) {
      return a.date.compareTo(b.date);
    });
  }
}
