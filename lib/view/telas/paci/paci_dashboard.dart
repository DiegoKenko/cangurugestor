import 'package:cangurugestor/global.dart';
import 'package:cangurugestor/view/componentes/item_container_tarefa.dart';
import 'package:cangurugestor/view/componentes/styles.dart';
import 'package:cangurugestor/view/componentes/tab.dart';
import 'package:cangurugestor/viewModel/provider_paciente.dart';
import 'package:cangurugestor/viewModel/provider_tarefas.dart';
import 'package:flutter/material.dart';
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
    context.read<TarefasProvider>().paciente =
        context.read<PacienteProvider>().paciente;
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
            context.read<TarefasProvider>().clear();
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
          TarefasPeriodo(data: EnumFiltroDataTarefa.estaSemana),
        ],
      ),
    );
  }
}

class TarefasPeriodo extends StatelessWidget {
  const TarefasPeriodo({
    super.key,
    required this.data,
  });
  final EnumFiltroDataTarefa data;

  @override
  Widget build(BuildContext context) {
    return Consumer<TarefasProvider>(builder: (context, provider, _) {
      context.read<TarefasProvider>().loadTodasTarefas(data);
      return ListView.builder(
          itemCount: provider.tarefas.length,
          itemBuilder: (context, index) {
            return ItemContainerTarefa(tarefa: provider.tarefas[index]);
          });
    });
  }
}
