import 'package:cangurugestor/view/componentes/drawer.dart';
import 'package:cangurugestor/view/componentes/item_container.dart';
import 'package:cangurugestor/view/componentes/styles.dart';
import 'package:cangurugestor/view/componentes/tab.dart';
import 'package:cangurugestor/viewModel/provider_cuidador.dart';
import 'package:cangurugestor/viewModel/provider_paciente.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PainelCuidador extends StatefulWidget {
  const PainelCuidador({Key? key}) : super(key: key);

  @override
  State<PainelCuidador> createState() => _PainelCuidadorState();
}

class _PainelCuidadorState extends State<PainelCuidador>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final CuidadorProvider cuidadorProvider = context.watch<CuidadorProvider>();
    return Scaffold(
      drawer: CanguruDrawer(drawerListTile: [
        DrawerListTile(
          title: Column(
            children: [
              Text(cuidadorProvider.cuidador.nome, style: kTitleAppBarStyle),
              Text('cuidador', style: kSubtitleAppBarStyle),
            ],
          ),
          onTap: null,
        ),
      ]),
      appBar: AppBar(),
      body: SafeArea(
        child: TabCanguru(
          controller: _tabController,
          tabs: const [
            Tab(
              text: 'Pacientes',
            ),
            Tab(
              text: 'Tarefas',
            ),
          ],
          views: [
            Tab(
              child: PacientesCuidador(tabController: _tabController),
            ),
            const Tab(
              child: TarefasCuidadorPaciente(),
            ),
          ],
        ),
      ),
    );
  }
}

class TarefasCuidadorPaciente extends StatelessWidget {
  const TarefasCuidadorPaciente({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class PacientesCuidador extends StatelessWidget {
  const PacientesCuidador({
    Key? key,
    required this.tabController,
  }) : super(key: key);
  final TabController tabController;

  @override
  Widget build(BuildContext context) {
    final CuidadorProvider cuidadorProvider = context.watch<CuidadorProvider>();
    return Builder(builder: (context) {
      cuidadorProvider.todosPacientes();
      return ListView.builder(
        itemCount: cuidadorProvider.pacientes.length,
        itemBuilder: ((context, index) {
          return ItemContainer(
            title: cuidadorProvider.pacientes[index].nome,
            onTap: () {
              context.read<PacienteProvider>().paciente =
                  cuidadorProvider.pacientes[index];
              tabController.animateTo(1);
            },
          );
        }),
      );
    });
  }
}
