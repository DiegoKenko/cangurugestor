import 'package:cangurugestor/view/componentes/animated_page_transition.dart';
import 'package:cangurugestor/view/componentes/drawer.dart';
import 'package:cangurugestor/view/componentes/item_container.dart';
import 'package:cangurugestor/view/componentes/styles.dart';
import 'package:cangurugestor/view/componentes/tab.dart';
import 'package:cangurugestor/view/telas/paci/paci_dashboard.dart';
import 'package:cangurugestor/viewModel/provider_paciente.dart';
import 'package:cangurugestor/viewModel/provider_responsavel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PainelResponsavel extends StatefulWidget {
  const PainelResponsavel({Key? key}) : super(key: key);

  @override
  State<PainelResponsavel> createState() => _PainelResponsavelState();
}

class _PainelResponsavelState extends State<PainelResponsavel>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ResponsavelProvider responsavelProvider =
        context.watch<ResponsavelProvider>();
    return Scaffold(
      drawer: CanguruDrawer(
        drawerListTile: [
          DrawerListTile(
            title: Column(
              children: [
                Text(responsavelProvider.responsavel.nome,
                    style: kTitleAppBarStyle),
                Text('responsavel', style: kSubtitleAppBarStyle),
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
            Tab(
              text: 'Contratos',
            ),
          ],
          views: [
            const Tab(
              child: PacientesCuidador(),
            ),
            Tab(
              child: Container(),
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
    final ResponsavelProvider responsavelProvider =
        context.watch<ResponsavelProvider>();
    return Builder(builder: (context) {
      responsavelProvider.todosPacientes();
      return ListView.builder(
        itemCount: responsavelProvider.pacientes.length,
        itemBuilder: ((context, index) {
          return ItemContainer(
            title: responsavelProvider.pacientes[index].nome,
            onTap: () {
              context.read<PacienteProvider>().clear();
              context.read<PacienteProvider>().paciente =
                  responsavelProvider.pacientes[index];
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
