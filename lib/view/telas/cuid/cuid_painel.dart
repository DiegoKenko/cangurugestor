import 'package:cangurugestor/model/paciente.dart';
import 'package:cangurugestor/view/componentes/animated_page_transition.dart';
import 'package:cangurugestor/view/componentes/drawer.dart';
import 'package:cangurugestor/view/componentes/item_container.dart';
import 'package:cangurugestor/view/componentes/styles.dart';
import 'package:cangurugestor/view/componentes/tab.dart';
import 'package:cangurugestor/view/telas/paci/paci_dashboard.dart';
import 'package:cangurugestor/viewModel/bloc_cuidador.dart';
import 'package:cangurugestor/viewModel/bloc_paciente.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    final CuidadorBloc cuidadorBloc = context.watch<CuidadorBloc>();
    return Scaffold(
      drawer: CanguruDrawer(
        profile: [
          DrawerListTile(
            title: Column(
              children: [
                Text(
                  cuidadorBloc.state.cuidador.nome,
                  style: kTitleAppBarStyle,
                ),
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
    return BlocBuilder<CuidadorBloc, CuidadorState>(
      builder: (context, state) {
        context.read<CuidadorBloc>().add(CuidadorLoadPacientesEvent());
        return ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: state.cuidador.pacientes.length,
          itemBuilder: ((context, index) {
            Paciente paciente = state.cuidador.pacientes[index];
            return ItemContainer(
              title: paciente.nome,
              onTap: () {
                Navigator.of(context).push(
                  AnimatedPageTransition(
                    page: BlocProvider<PacienteBloc>(
                      create: (context) => PacienteBloc(paciente),
                      child: const PacienteDashboard(),
                    ),
                  ),
                );
              },
            );
          }),
        );
      },
    );
  }
}
