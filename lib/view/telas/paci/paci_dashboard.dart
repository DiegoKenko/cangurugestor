import 'package:cangurugestor/firebaseUtils/fire_tarefa.dart';
import 'package:cangurugestor/global.dart';
import 'package:cangurugestor/model/cuidador.dart';
import 'package:cangurugestor/model/paciente.dart';
import 'package:cangurugestor/model/tarefa.dart';
import 'package:cangurugestor/view/componentes/item_container_tarefa.dart';
import 'package:cangurugestor/view/componentes/styles.dart';
import 'package:cangurugestor/view/componentes/tab.dart';
import 'package:cangurugestor/viewModel/bloc_cuidador.dart';
import 'package:cangurugestor/viewModel/bloc_paciente.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class PacienteDashboard extends StatefulWidget {
  const PacienteDashboard({Key? key}) : super(key: key);

  @override
  State<PacienteDashboard> createState() => _PacienteDashboardState();
}

class _PacienteDashboardState extends State<PacienteDashboard>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 4, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tarefas',
          style: kTitleAppBarStyle,
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: TabCanguru(
        controller: _tabController,
        direction: VerticalDirection.up,
        tabs: [
          Tab(
            child: Text(
              'Ontem',
              style: kTabStyle,
            ),
          ),
          Tab(
            child: Text(
              'Hoje',
              style: kTabStyle,
            ),
          ),
          Tab(
            child: Text(
              'Amanhã',
              style: kTabStyle,
            ),
          ),
          Tab(
            child: Text(
              'Semana',
              style: kTabStyle,
            ),
          ),
        ],
        views: const [
          TarefasPeriodo(data: EnumFiltroDataTarefa.ontem),
          TarefasPeriodo(data: EnumFiltroDataTarefa.hoje),
          TarefasPeriodo(data: EnumFiltroDataTarefa.amanha),
          TarefasPeriodo(data: EnumFiltroDataTarefa.proxSemana),
        ],
      ),
    );
  }
}

class TarefasPeriodo extends StatefulWidget {
  const TarefasPeriodo({
    super.key,
    required this.data,
  });
  final EnumFiltroDataTarefa data;

  @override
  State<TarefasPeriodo> createState() => _TarefasPeriodoState();
}

class _TarefasPeriodoState extends State<TarefasPeriodo> {
  @override
  Widget build(BuildContext context) {
    final CuidadorBloc cuidadorBloc = context.read<CuidadorBloc>();
    final PacienteBloc pacienteBloc = context.read<PacienteBloc>();
    return FutureBuilder(
      future: getTodasTarefasFiltro(
        widget.data,
        context.read<PacienteBloc>().state.paciente,
      ),
      builder: (builder, snap) {
        var tarefas = snap.data ?? [];
        if (tarefas.isEmpty) {
          return const Center(
            child: Text('Não há tarefas para o período'),
          );
        }
        return ListView.builder(
          itemCount: tarefas.length,
          itemBuilder: (context, index) {
            return ItemContainerTarefa(
              tarefa: tarefas[index],
              onTap: () {
                showModalBottomSheet(
                  isScrollControlled: true,
                  isDismissible: false,
                  elevation: 10,
                  context: context,
                  builder: (context) {
                    return BlocProvider.value(
                      value: pacienteBloc,
                      child: BlocProvider.value(
                        value: cuidadorBloc,
                        child: TarefaBottomSheet(
                          tarefa: tarefas[index],
                        ),
                      ),
                    );
                  },
                ).then((value) => setState(() {}));
              },
            );
          },
        );
      },
    );
  }

  Future<List<Tarefa>> getTodasTarefasFiltro(
    EnumFiltroDataTarefa filtro,
    Paciente paciente,
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
