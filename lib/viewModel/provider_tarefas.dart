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
    notifyListeners();
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
              medicamento.intervalo,
              medicamento.intervaloQuantidade,
            ).toInt(),
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
              atividade.frequenciaMedida,
              atividade.frequenciaQuantidade,
            ).toInt(),
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

  Future<void> load() async {
    if (paciente.id != '' && tipo != EnumTarefa.nenhuma && idItem.isNotEmpty) {
      _tarefas = await FirestoreTarefa()
          .todasTarefasItem(paciente, tipo.collection, idItem);
    } else {
      _tarefas = [];
    }
  }

  Future<void> delete(Tarefa tarefa) async {
    await FirestoreTarefa().delete(paciente.id, tarefa.id);
  }

  Future<void> loadTodasTarefasFiltro(EnumFiltroDataTarefa filtro) async {
    if (paciente.id.isNotEmpty) {
      switch (filtro) {
        case EnumFiltroDataTarefa.ontem:
          _tarefas = await FirestoreTarefa().todasTarefasOntem(paciente);
          break;
        case EnumFiltroDataTarefa.hoje:
          _tarefas = await FirestoreTarefa().todasTarefasHoje(paciente);
          break;
        case EnumFiltroDataTarefa.amanha:
          _tarefas = await FirestoreTarefa().todasTarefasAmanha(paciente);
          break;
        case EnumFiltroDataTarefa.proxSemana:
          _tarefas = await FirestoreTarefa().todasTarefasSemana(paciente);
          break;
        default:
          _tarefas = await FirestoreTarefa().todasTarefasOntem(paciente);
      }
    } else {
      _tarefas = [];
    }

    notifyListeners();
  }

  Future<List<Tarefa>> getTodasTarefasFiltro(
    EnumFiltroDataTarefa filtro,
  ) async {
    List<Tarefa> tarefas = [];
    if (paciente.id.isNotEmpty) {
      switch (filtro) {
        case EnumFiltroDataTarefa.ontem:
          tarefas = await FirestoreTarefa().todasTarefasOntem(paciente);
          break;
        case EnumFiltroDataTarefa.hoje:
          tarefas = await FirestoreTarefa().todasTarefasHoje(paciente);
          break;
        case EnumFiltroDataTarefa.amanha:
          tarefas = await FirestoreTarefa().todasTarefasAmanha(paciente);
          break;
        case EnumFiltroDataTarefa.proxSemana:
          tarefas = await FirestoreTarefa().todasTarefasSemana(paciente);
          break;
        default:
          tarefas = await FirestoreTarefa().todasTarefasOntem(paciente);
      }
    } else {
      tarefas = [];
    }

    return tarefas;
  }
}
