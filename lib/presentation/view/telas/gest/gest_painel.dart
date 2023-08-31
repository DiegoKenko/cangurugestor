import 'package:cangurugestor/domain/entity/cuidador_entity.dart';
import 'package:cangurugestor/domain/entity/responsavel_entity.dart';
import 'package:cangurugestor/presentation/controller/gestor_controller.dart';
import 'package:cangurugestor/presentation/state/gestor_state.dart';
import 'package:cangurugestor/presentation/view/componentes/adicionar_botao_rpc.dart';
import 'package:cangurugestor/presentation/view/componentes/animated_page_transition.dart';
import 'package:cangurugestor/presentation/view/componentes/drawer.dart';
import 'package:cangurugestor/presentation/view/componentes/item_container.dart';
import 'package:cangurugestor/presentation/view/componentes/styles.dart';
import 'package:cangurugestor/presentation/view/componentes/tab.dart';
import 'package:cangurugestor/presentation/view/telas/cuid/cuid_cadastro.dart';
import 'package:cangurugestor/presentation/view/telas/resp/resp_cadastro.dart';
import 'package:flutter/material.dart';

class PainelGestor extends StatefulWidget {
  const PainelGestor({Key? key}) : super(key: key);

  @override
  State<PainelGestor> createState() => _PainelGestorState();
}

class _PainelGestorState extends State<PainelGestor>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final GestorController gestorController = GestorController();

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
          ValueListenableBuilder(
            valueListenable: gestorController,
            builder: (context, state, _) {
              if (state is GestorSuccessState) {
                return DrawerListTile(
                  title: Column(
                    children: [
                      Text(state.gestor.nome, style: kTitleAppBarStyle),
                      Text('gestor', style: kSubtitleAppBarStyle),
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
  final GestorController gestorController = GestorController();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ValueListenableBuilder(
            valueListenable: gestorController,
            builder: ((context, gestorState, _) {
              if (gestorState is GestorSuccessState) {
                return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: gestorState.gestor.cuidadores.length,
                  itemBuilder: (context, index) {
                    CuidadorEntity cuidador =
                        gestorState.gestor.cuidadores[index];
                    return ItemContainer(
                      leading: const CircleAvatar(
                        backgroundImage: AssetImage('assets/avatar.png'),
                      ),
                      title: cuidador.nome,
                      subtitle: cuidador.sobrenome,
                      onTap: () {
                        Navigator.of(context).push(
                          AnimatedPageTransition(
                            page: const CadastroCuidador(),
                          ),
                        );
                      },
                    );
                  },
                );
              }
              return const Text('nenhum cuidador cadastrado');
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
                    page: const CadastroCuidador(),
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
          child: ValueListenableBuilder(
            valueListenable: GestorController(),
            builder: (context, gestorState, _) {
              if (gestorState is GestorSuccessState) {
                return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: gestorState.gestor.clientes.length,
                  itemBuilder: (context, index) {
                    ResponsavelEntity responsavel =
                        gestorState.gestor.clientes[index];
                    return ItemContainer(
                      leading: const CircleAvatar(
                        backgroundImage: AssetImage('assets/avatar.png'),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          AnimatedPageTransition(
                            page: const CadastroResponsavel(),
                          ),
                        );
                      },
                      title: responsavel.nome,
                    );
                  },
                );
              }
              return const Text('nenhum cliente cadastrado');
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
                  page: const CadastroResponsavel(),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
