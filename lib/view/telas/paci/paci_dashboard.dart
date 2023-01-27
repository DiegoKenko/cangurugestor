import 'package:cangurugestor/global.dart';
import 'package:cangurugestor/view/componentes/drawer.dart';
import 'package:cangurugestor/view/componentes/item_container.dart';
import 'package:cangurugestor/viewModel/provider_tarefas.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PacienteDashboard extends StatefulWidget {
  const PacienteDashboard({Key? key}) : super(key: key);

  @override
  State<PacienteDashboard> createState() => _PacienteDashboardState();
}

class _PacienteDashboardState extends State<PacienteDashboard> {
  EnumFiltroDataTarefa dataSelecao = EnumFiltroDataTarefa.hoje;
  @override
  Widget build(BuildContext context) {
    final TarefasProvider tarefasProvider = context.watch<TarefasProvider>();
    return Scaffold(
      drawer: CanguruDrawer(),
      appBar: AppBar(),
      body: Builder(builder: (context) {
        tarefasProvider.loadTodasTarefas(dataSelecao);
        return ListView.builder(
            itemCount: tarefasProvider.tarefas.length,
            itemBuilder: (context, index) {
              return ItemContainer(
                title: tarefasProvider.tarefas[index].date,
                subtitle: tarefasProvider.tarefas[index].descricao,
              );
            });
      }),
      bottomNavigationBar: SegmentedButton<EnumFiltroDataTarefa>(
        selected: <EnumFiltroDataTarefa>{dataSelecao},
        onSelectionChanged: (p0) {
          dataSelecao = p0.first;
        },
        segments: const <ButtonSegment<EnumFiltroDataTarefa>>[
          ButtonSegment<EnumFiltroDataTarefa>(
            value: EnumFiltroDataTarefa.ontem,
            label: Text('Ontem'),
          ),
          ButtonSegment<EnumFiltroDataTarefa>(
            value: EnumFiltroDataTarefa.ontem,
            label: Text('Hoje'),
          ),
          ButtonSegment<EnumFiltroDataTarefa>(
            value: EnumFiltroDataTarefa.ontem,
            label: Text('Amanhã'),
          ),
          ButtonSegment<EnumFiltroDataTarefa>(
            value: EnumFiltroDataTarefa.ontem,
            label: Text('Esta semana'),
          ),
        ],
      ),
    );
  }
}
