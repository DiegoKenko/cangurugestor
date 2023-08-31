import 'package:cangurugestor/domain/entity/paciente_entity.dart';
import 'package:cangurugestor/presentation/controller/cuidador_controller.dart';
import 'package:cangurugestor/presentation/state/cuidador_state.dart';
import 'package:cangurugestor/presentation/view/componentes/animated_page_transition.dart';
import 'package:cangurugestor/presentation/view/componentes/drawer.dart';
import 'package:cangurugestor/presentation/view/componentes/item_container.dart';
import 'package:cangurugestor/presentation/view/componentes/styles.dart';
import 'package:cangurugestor/presentation/view/componentes/tab.dart';
import 'package:cangurugestor/presentation/view/telas/paci/paci_dashboard.dart';
import 'package:flutter/material.dart';

class PainelCuidador extends StatefulWidget {
  const PainelCuidador({Key? key}) : super(key: key);

  @override
  State<PainelCuidador> createState() => _PainelCuidadorState();
}

class _PainelCuidadorState extends State<PainelCuidador>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final CuidadorController cuidadorController = CuidadorController();

  @override
  void initState() {
    _tabController = TabController(length: 1, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CanguruDrawer(
        profile: [
          ValueListenableBuilder(
            valueListenable: cuidadorController,
            builder: (context, state, _) {
              if (state is CuidadorSuccessState) {
                return DrawerListTile(
                  title: Column(
                    children: [
                      Text(
                        state.cuidador.nome,
                        style: kTitleAppBarStyle,
                      ),
                      Text('cuidador', style: kSubtitleAppBarStyle),
                    ],
                  ),
                  onTap: null,
                );
              }
              return Container();
            },
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

class PacientesCuidador extends StatefulWidget {
  const PacientesCuidador({
    Key? key,
  }) : super(key: key);

  @override
  State<PacientesCuidador> createState() => _PacientesCuidadorState();
}

class _PacientesCuidadorState extends State<PacientesCuidador> {
  final CuidadorController cuidadorController = CuidadorController();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: cuidadorController,
      builder: (context, state, _) {
        if (state is CuidadorSuccessState) {
          return ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: state.cuidador.pacientes.length,
            itemBuilder: ((context, index) {
              PacienteEntity paciente = state.cuidador.pacientes[index];
              return ItemContainer(
                title: paciente.nome,
                onTap: () {
                  Navigator.of(context).push(
                    AnimatedPageTransition(
                      page: const PacienteDashboard(),
                    ),
                  );
                },
              );
            }),
          );
        }
        return Container();
      },
    );
  }
}
