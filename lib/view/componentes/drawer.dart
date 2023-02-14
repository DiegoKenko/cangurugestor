import 'package:cangurugestor/view/componentes/animated_page_transition.dart';
import 'package:cangurugestor/view/componentes/styles.dart';
import 'package:cangurugestor/view/telas/tela_relatorio.dart';
import 'package:cangurugestor/view/telas/tela_login.dart';
import 'package:cangurugestor/viewModel/provider_atividade.dart';
import 'package:cangurugestor/viewModel/provider_consulta.dart';
import 'package:cangurugestor/viewModel/provider_cuidador.dart';
import 'package:cangurugestor/viewModel/provider_gestor.dart';
import 'package:cangurugestor/viewModel/bloc_auth.dart';
import 'package:cangurugestor/viewModel/provider_medicamento.dart';
import 'package:cangurugestor/viewModel/provider_paciente.dart';
import 'package:cangurugestor/viewModel/provider_responsavel.dart';
import 'package:cangurugestor/viewModel/provider_tarefas.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';

class CanguruDrawer extends StatefulWidget {
  const CanguruDrawer({
    Key? key,
    this.profile = const [],
  }) : super(key: key);
  final List<Widget> profile;

  @override
  State<CanguruDrawer> createState() => _CanguruDrawerState();
}

class _CanguruDrawerState extends State<CanguruDrawer> {
  late final AuthBloc _authBloc;

  @override
  void initState() {
    _authBloc = context.read<AuthBloc>();
    super.initState();
  }

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
                flex: 1,
                child: Column(
                  children: widget.profile,
                ),
              ),
              Expanded(
                flex: 1,
                child: _authBloc.state.login.gerarRelatorioCuidador
                    ? DrawerListTile(
                        title: const Text(
                          'Relatórios',
                          style: TextStyle(color: Colors.white),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            AnimatedPageTransition(
                              page: const RelatorioTela(),
                            ),
                          );
                        },
                      )
                    : Container(),
              ),
              Expanded(
                flex: 6,
                child: Container(),
              ),
              Flexible(
                flex: 1,
                child: FutureBuilder(
                  future: PackageInfo.fromPlatform(),
                  builder: (context, snap) {
                    if (snap.hasData) {
                      return DrawerListTile(
                        title: const Text(
                          'Sobre',
                          style: TextStyle(color: Colors.white),
                        ),
                        onTap: () async {
                          showAboutDialog(
                            context: context,
                            applicationName: snap.data!.appName,
                            applicationVersion: 'versão ${snap.data!.version}',
                            applicationIcon: const Icon(Icons.phone_android),
                            applicationLegalese: 'DESENVOLVIDO POR: \n\n'
                                'Inora Softwares LTDA \n'
                                'www.inora.com.br \n'
                                'cnpj: 48.738.803/0001-74',
                          );
                        },
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
              ),
              Flexible(
                flex: 1,
                child: DrawerListTile(
                  title: const Text(
                    'Sair',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    _authBloc.add(LogoutEvent());
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
