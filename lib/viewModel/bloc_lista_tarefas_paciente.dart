import 'package:cangurugestor/enum/enum_intervalo.dart';
import 'package:cangurugestor/enum/enum_tarefa.dart';
import 'package:cangurugestor/datasource/atividade/fire_atividade.dart';
import 'package:cangurugestor/datasource/consulta/fire_consulta.dart';
import 'package:cangurugestor/datasource/medicamento/fire_medicamento.dart';
import 'package:cangurugestor/datasource/tarefa/fire_tarefa.dart';
import 'package:cangurugestor/model/atividade.dart';
import 'package:cangurugestor/model/consulta.dart';
import 'package:cangurugestor/model/medicamento.dart';
import 'package:cangurugestor/model/paciente.dart';
import 'package:cangurugestor/model/tarefa.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class ListaTarefaPacienteState {
  Paciente paciente = Paciente();
  EnumTarefa tipo = EnumTarefa.nenhuma;
  List<Tarefa> tarefas = [];
  String idTipo = '';
  bool loaded = false;

  ListaTarefaPacienteState({
    required this.paciente,
    required this.tipo,
    required this.idTipo,
    required this.tarefas,
    required this.loaded,
  });
}

class ListaTarefasInitialState extends ListaTarefaPacienteState {
  ListaTarefasInitialState()
      : super(
          loaded: false,
          paciente: Paciente(),
          tipo: EnumTarefa.nenhuma,
          idTipo: '',
          tarefas: [],
        );
}

class ListaTarefasReadyState extends ListaTarefaPacienteState {
  ListaTarefasReadyState(
    Paciente paciente,
    EnumTarefa tipo,
    String idTipo,
    List<Tarefa> tarefas,
  ) : super(
          paciente: paciente,
          tipo: tipo,
          idTipo: idTipo,
          tarefas: tarefas,
          loaded: true,
        );
}

abstract class ListaTarefaEvent {
  ListaTarefaEvent();
}

class ListaTarefasLoadEvent extends ListaTarefaEvent {
  EnumFiltroDataTarefa filtro = EnumFiltroDataTarefa.todos;
  Paciente paciente;
  EnumTarefa tipo;
  String idTipo;
  ListaTarefasLoadEvent({
    required this.paciente,
    required this.tipo,
    required this.idTipo,
    this.filtro = EnumFiltroDataTarefa.todos,
  });
}

class ListaTarefasAddEvent extends ListaTarefaEvent {
  EnumTarefa tipo;
  ListaTarefasAddEvent(this.tipo);
}

class ListaTarefasRemoveEvent extends ListaTarefaEvent {
  Tarefa tarefa;
  ListaTarefasRemoveEvent(this.tarefa);
}

class ListaTarefasPacienteBloc
    extends Bloc<ListaTarefaEvent, ListaTarefaPacienteState> {
  ListaTarefasPacienteBloc() : super(ListaTarefasInitialState()) {
    on<ListaTarefasLoadEvent>((event, emit) async {
      switch (event.filtro) {
        case EnumFiltroDataTarefa.ontem:
          state.tarefas =
              await FirestoreTarefa().todasTarefasOntem(event.paciente);
          break;
        case EnumFiltroDataTarefa.hoje:
          state.tarefas =
              await FirestoreTarefa().todasTarefasHoje(event.paciente);
          break;
        case EnumFiltroDataTarefa.amanha:
          state.tarefas =
              await FirestoreTarefa().todasTarefasAmanha(event.paciente);
          break;
        case EnumFiltroDataTarefa.proxSemana:
          state.tarefas =
              await FirestoreTarefa().todasTarefasSemana(event.paciente);
          break;
        case EnumFiltroDataTarefa.todos:
          state.tarefas = await FirestoreTarefa()
              .todasTarefasItem(event.paciente, event.tipo, event.idTipo);
          break;
        default:
          state.tarefas =
              await FirestoreTarefa().todasTarefasHoje(event.paciente);
      }

      emit(
        ListaTarefasReadyState(
          event.paciente,
          event.tipo,
          event.idTipo,
          state.tarefas,
        ),
      );
    });

    on<ListaTarefasAddEvent>((event, emit) async {
      Tarefa tarefa = Tarefa();
      if (event.tipo == EnumTarefa.medicamento) {
        Medicamento medicamento = await FirestoreMedicamento()
            .medicamentoPaciente(state.idTipo, state.paciente.id);
        if (state.tarefas.isEmpty) {
          tarefa = Tarefa.init(
            dateTime: DateTime.now(),
            nome: medicamento.nome,
            descricao: medicamento.descricao,
            observacao: medicamento.observacao,
            tipo: EnumTarefa.medicamento,
            idTipo: state.idTipo,
          );
        } else {
          tarefa = Tarefa.init(
            dateTime: state.tarefas.last.dateTime.add(
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
            idTipo: state.idTipo,
          );
        }
      } else if (event.tipo == EnumTarefa.consulta) {
        Consulta consulta = await FirestoreConsulta()
            .consultaPaciente(state.idTipo, state.paciente.id);
        if (state.tarefas.isEmpty) {
          tarefa = Tarefa.init(
            dateTime: DateTime.now(),
            nome: consulta.descricao,
            descricao: consulta.medico,
            observacao: consulta.observacao,
            tipo: EnumTarefa.consulta,
            idTipo: state.idTipo,
          );
        } else {
          tarefa = Tarefa.init(
            dateTime: state.tarefas.last.dateTime.add(
              const Duration(days: 7),
            ),
            nome: consulta.descricao,
            descricao: consulta.medico,
            observacao: consulta.observacao,
            tipo: EnumTarefa.consulta,
            idTipo: state.idTipo,
          );
        }
      } else if (event.tipo == EnumTarefa.atividade) {
        Atividade atividade = await FirestoreAtividade()
            .atividadePaciente(state.idTipo, state.paciente.id);
        if (state.tarefas.isEmpty) {
          tarefa = Tarefa.init(
            dateTime: DateTime.now(),
            nome: atividade.descricao,
            descricao: atividade.local,
            observacao: atividade.observacao,
            tipo: EnumTarefa.atividade,
            idTipo: state.idTipo,
          );
        } else {
          tarefa = Tarefa.init(
            dateTime: state.tarefas.last.dateTime.add(
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
            idTipo: state.idTipo,
          );
        }
      }

      tarefa = await FirestoreTarefa().insert(state.paciente, tarefa);
      emit(
        ListaTarefasReadyState(
          state.paciente,
          state.tipo,
          state.idTipo,
          [...state.tarefas, tarefa],
        ),
      );
    });

    on<ListaTarefasRemoveEvent>((event, emit) async {
      await FirestoreTarefa().delete(state.paciente.id, event.tarefa.id);
      state.tarefas.remove(event.tarefa);
      emit(
        ListaTarefasReadyState(
          state.paciente,
          state.tipo,
          state.idTipo,
          state.tarefas,
        ),
      );
    });
  }
}
