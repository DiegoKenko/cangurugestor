import 'package:cangurugestor/const/enum/enum_tarefa.dart';
import 'package:cangurugestor/const/global.dart';
import 'package:cangurugestor/domain/entity/paciente_entity.dart';
import 'package:cangurugestor/domain/entity/tarefa_entity.dart';
import 'package:cangurugestor/presentation/controller/paciente_tarefas_controller.dart';
import 'package:cangurugestor/presentation/state/paciente_tarefas_state.dart';
import 'package:cangurugestor/presentation/view/componentes/item_container_tarefa.dart';
import 'package:cangurugestor/presentation/view/componentes/styles.dart';
import 'package:cangurugestor/presentation/view/componentes/tab.dart';
import 'package:cangurugestor/presentation/controller/cuidador_controller.dart';
import 'package:flutter/material.dart';

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
  final PacienteTarefasController pacienteTarefasController =
      getIt<PacienteTarefasController>();
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: pacienteTarefasController,
      builder: (builder, state, _) {
        var tarefas = [];
        if (state is ListaTarefasSuccessState) {
          tarefas = state.tarefas;
        }
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
                    return TarefaBottomSheet(
                      tarefa: tarefas[index],
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
}
