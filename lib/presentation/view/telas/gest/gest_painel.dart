import 'package:cangurugestor/domain/entity/cuidador.dart';
import 'package:cangurugestor/domain/entity/responsavel.dart';
import 'package:cangurugestor/presentation/view/componentes/adicionar_botao_rpc.dart';
import 'package:cangurugestor/presentation/view/componentes/animated_page_transition.dart';
import 'package:cangurugestor/presentation/view/componentes/drawer.dart';
import 'package:cangurugestor/presentation/view/componentes/item_container.dart';
import 'package:cangurugestor/presentation/view/componentes/styles.dart';
import 'package:cangurugestor/presentation/view/componentes/tab.dart';
import 'package:cangurugestor/presentation/view/telas/cuid/cuid_cadastro.dart';
import 'package:cangurugestor/presentation/view/telas/resp/resp_cadastro.dart';
import 'package:cangurugestor/presentation/controller/gestor_controller.dart';
import 'package:cangurugestor/presentation/controller/cuidador_controller.dart';
import 'package:cangurugestor/presentation/controller/responsavel_controller.dart';
import 'package:flutter/material.dart';

class PainelGestor extends StatefulWidget {
  const PainelGestor({Key? key}) : super(key: key);

  @override
  State<PainelGestor> createState() => _PainelGestorState();
}

class _PainelGestorState extends State<PainelGestor>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CanguruDrawer(
        profile: [
          DrawerListTile(
            title: Column(
              children: [
                Text(gestorState.gestor.nome, style: kTitleAppBarStyle),
                Text('gestor', style: kSubtitleAppBarStyle),
              ],
            ),
            onTap: null,
          ),
        ],
      ),
      appBar: AppBar(
        backgroundColor: corPad1,
      ),
      body: SafeArea(
        child: TabCanguru(
          controller: _tabController,
          tabs: const [
            Tab(
              text: 'Clientes',
            ),
            Tab(
              text: 'Cuidadores',
            ),
          ],
          views: const [
            Tab(
              child: ClientesGestor(),
            ),
            Tab(
              child: CuidadoresGestor(),
            ),
          ],
        ),
      ),
    );
  }
}

class CuidadoresGestor extends StatefulWidget {
  const CuidadoresGestor({
    Key? key,
  }) : super(key: key);

  @override
  State<CuidadoresGestor> createState() => _CuidadoresGestorState();
}

class _CuidadoresGestorState extends State<CuidadoresGestor> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: BlocBuilder<GestorBloc, GestorState>(
            builder: ((context, gestorState) {
              context.read<GestorBloc>().add(GestorLoadCuidadoresEvent());
              if (gestorState.gestor.cuidadores.isEmpty) {
                return const Text('nenhum cuidador cadastrado');
              } else {
                return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: gestorState.gestor.cuidadores.length,
                  itemBuilder: (context, index) {
                    Cuidador cuidador = gestorState.gestor.cuidadores[index];
                    return ItemContainer(
                      leading: const CircleAvatar(
                        backgroundImage: AssetImage('assets/avatar.png'),
                      ),
                      title: cuidador.nome,
                      subtitle: cuidador.sobrenome,
                      onTap: () {
                        Navigator.of(context).push(
                          AnimatedPageTransition(
                            page: BlocProvider<CuidadorBloc>(
                              create: (context) {
                                return CuidadorBloc(cuidador);
                              },
                              child: const CadastroCuidador(),
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              }
            }),
          ),
        ),
        SizedBox(
          height: 50,
          child: Center(
            child: BotaoCadastro(
              onPressed: () {
                Navigator.of(context).push(
                  AnimatedPageTransition(
                    page: BlocProvider<CuidadorBloc>(
                      create: (context) {
                        return CuidadorBloc(
                          Cuidador.initOnAdd(
                            context.read<GestorBloc>().state.gestor.id,
                          ),
                        );
                      },
                      child: const CadastroCuidador(),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class ClientesGestor extends StatelessWidget {
  const ClientesGestor({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: BlocBuilder<GestorBloc, GestorState>(
            builder: (context, gestorState) {
              context.read<GestorBloc>().add(GestorLoadClientesEvent());
              if (gestorState.gestor.clientes.isEmpty) {
                return const Text('nenhum cliente cadastrado');
              } else {
                return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: gestorState.gestor.clientes.length,
                  itemBuilder: (context, index) {
                    Responsavel responsavel =
                        gestorState.gestor.clientes[index];
                    return ItemContainer(
                      leading: const CircleAvatar(
                        backgroundImage: AssetImage('assets/avatar.png'),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          AnimatedPageTransition(
                            page: BlocProvider<ResponsavelBloc>(
                              create: (context) => ResponsavelBloc(responsavel),
                              child: const CadastroResponsavel(),
                            ),
                          ),
                        );
                      },
                      title: responsavel.nome,
                    );
                  },
                );
              }
            },
          ),
        ),
        SizedBox(
          height: 50,
          child: BotaoCadastro(
            onPressed: () {
              Navigator.push(
                context,
                AnimatedPageTransition(
                  page: BlocProvider(
                    create: (context) => ResponsavelBloc(
                      Responsavel.initOnAdd(
                        context.read<GestorBloc>().state.gestor.id,
                      ),
                    ),
                    child: const CadastroResponsavel(),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
