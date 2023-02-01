import 'package:cangurugestor/view/componentes/animated_page_transition.dart';
import 'package:cangurugestor/view/componentes/styles.dart';
import 'package:cangurugestor/view/telas/tela_login.dart';
import 'package:cangurugestor/viewModel/provider_atividade.dart';
import 'package:cangurugestor/viewModel/provider_consulta.dart';
import 'package:cangurugestor/viewModel/provider_cuidador.dart';
import 'package:cangurugestor/viewModel/provider_gestor.dart';
import 'package:cangurugestor/viewModel/provider_login.dart';
import 'package:cangurugestor/viewModel/provider_medicamento.dart';
import 'package:cangurugestor/viewModel/provider_paciente.dart';
import 'package:cangurugestor/viewModel/provider_responsavel.dart';
import 'package:cangurugestor/viewModel/provider_tarefas.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CanguruDrawer extends StatelessWidget {
  const CanguruDrawer({
    Key? key,
    this.drawerListTile = const [],
  }) : super(key: key);
  final List<Widget> drawerListTile;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: corPad1,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: Column(
            children: [
              Expanded(
                flex: 9,
                child: Column(
                  children: drawerListTile,
                ),
              ),
              Expanded(
                flex: 1,
                child: DrawerListTile(
                  title: const Text(
                    'Sair',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    context.read<LoginProvider>().logout();
                    context.read<GestorProvider>().clear();
                    context.read<PacienteProvider>().clear();
                    context.read<ResponsavelProvider>().clear();
                    context.read<CuidadorProvider>().clear();
                    context.read<MedicamentoProvider>().clear();
                    context.read<AtividadeProvider>().clear();
                    context.read<ConsultaProvider>().clear();
                    context.read<TarefasProvider>().clear();

                    Navigator.of(context).pushReplacement(
                      AnimatedPageTransition(
                        page: const TelaLogin(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    required this.title,
    required this.onTap,
  }) : super(key: key);
  final Widget title;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
      child: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Colors.white,
              width: 1,
            ),
            bottom: BorderSide(
              color: Colors.white,
              width: 1,
            ),
          ),
        ),
        child: Center(
          child: ListTile(
            title: title,
            onTap: onTap,
          ),
        ),
      ),
    );
  }
}
