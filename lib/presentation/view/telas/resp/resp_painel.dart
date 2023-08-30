import 'package:cangurugestor/domain/entity/paciente.dart';
import 'package:cangurugestor/presentation/view/componentes/animated_page_transition.dart';
import 'package:cangurugestor/presentation/view/componentes/drawer.dart';
import 'package:cangurugestor/presentation/view/componentes/item_container.dart';
import 'package:cangurugestor/presentation/view/componentes/styles.dart';
import 'package:cangurugestor/presentation/view/componentes/tab.dart';
import 'package:cangurugestor/presentation/view/componentes/tooltip_help.dart';
import 'package:cangurugestor/presentation/view/telas/paci/paci_dashboard.dart';
import 'package:cangurugestor/presentation/controller/paciente_controller.dart';
import 'package:cangurugestor/presentation/controller/viewModel/bloc_responsavel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    final ResponsavelBloc responsavelBloc = context.watch<ResponsavelBloc>();
    return Scaffold(
      drawer: CanguruDrawer(
        profile: [
          DrawerListTile(
            title: Column(
              children: [
                Text(
                  responsavelBloc.state.responsavel.nome,
                  style: kTitleAppBarStyle,
                ),
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
          views: const [
            Tab(
              child: PacientesCuidador(),
            ),
            Tab(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: TooltipHelp(
                  title: 'Nenhum contrato encontrado.',
                  tip:
                      '\n A agência de cuidados contratada ainda não apresentou contratos.',
                ),
              ),
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
    final ResponsavelBloc responsavelBloc = context.watch<ResponsavelBloc>();
    return Builder(
      builder: (context) {
        responsavelBloc.add(ResponsavelLoadPacientesEvent());
        if (responsavelBloc.state.responsavel.pacientes.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: TooltipHelp(
              title: 'Nenhum paciente encontrado.',
              tip:
                  "\n Seu perfil 'responsável' precisa estar vinculado a pelo menos paciente.\n\n Solicite à agência de cuidados contratada que faça o vínculo através do seu e-mail.",
            ),
          );
        }
        return ListView.builder(
          itemCount: responsavelBloc.state.responsavel.pacientes.length,
          itemBuilder: ((context, index) {
            Paciente paciente =
                responsavelBloc.state.responsavel.pacientes[index];
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
