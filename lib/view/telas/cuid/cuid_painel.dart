import 'package:cangurugestor/view/componentes/animated_page_transition.dart';
import 'package:cangurugestor/view/componentes/drawer.dart';
import 'package:cangurugestor/view/componentes/item_container.dart';
import 'package:cangurugestor/view/componentes/styles.dart';
import 'package:cangurugestor/view/componentes/tab.dart';
import 'package:cangurugestor/view/telas/paci/paci_dashboard.dart';
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
    _tabController = TabController(length: 1, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final CuidadorProvider cuidadorProvider = context.watch<CuidadorProvider>();
    return Scaffold(
      drawer: CanguruDrawer(
        profile: [
          DrawerListTile(
            title: Column(
              children: [
                Text(cuidadorProvider.cuidador.nome, style: kTitleAppBarStyle),
                Text('cuidador', style: kSubtitleAppBarStyle),
              ],
            ),
            onTap: null,
          ),
        ],
      ),
      appBar: AppBar(),
      body: SafeArea(
        child: TabCanguru(
          controller: _tabController,
          tabs: const [
            Tab(
              text: 'Pacientes',
            ),
          ],
          views: const [
            Tab(
              child: PacientesCuidador(),
            ),
          ],
        ),
      ),
    );
  }
}

class PacientesCuidador extends StatelessWidget {
  const PacientesCuidador({
    Key? key,
  }) : super(key: key);

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
              context.read<PacienteProvider>().clear();
              context.read<PacienteProvider>().paciente =
                  cuidadorProvider.pacientes[index];
              Navigator.of(context).push(
                AnimatedPageTransition(
                  page: const PacienteDashboard(),
                ),
              );
            },
          );
        }),
      );
    });
  }
}
