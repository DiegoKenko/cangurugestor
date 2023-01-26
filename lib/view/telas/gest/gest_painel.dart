import 'package:cangurugestor/model/cuidador.dart';
import 'package:cangurugestor/model/responsavel.dart';
import 'package:cangurugestor/view/componentes/adicionar_botao_rpc.dart';
import 'package:cangurugestor/view/componentes/animated_page_transition.dart';
import 'package:cangurugestor/view/componentes/drawer.dart';
import 'package:cangurugestor/view/componentes/item_container.dart';
import 'package:cangurugestor/view/componentes/styles.dart';
import 'package:cangurugestor/view/componentes/tab.dart';
import 'package:cangurugestor/view/telas/cuid/cuid_cadastro.dart';
import 'package:cangurugestor/view/telas/resp/resp_cadastro.dart';
import 'package:cangurugestor/viewModel/provider_cuidador.dart';
import 'package:cangurugestor/viewModel/provider_gestor.dart';
import 'package:cangurugestor/viewModel/provider_responsavel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    final GestorProvider gestorProvider = Provider.of<GestorProvider>(context);

    return Scaffold(
      drawer: const CanguruDrawer(),
      appBar: AppBar(
        backgroundColor: corPad1,
        title: Column(
          children: [
            Text(gestorProvider.gestor.nome, style: kTitleAppBarStyle),
            Text('gestor', style: kSubtitleAppBarStyle),
          ],
        ),
        centerTitle: true,
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
    final GestorProvider gestorProvider = Provider.of<GestorProvider>(context);

    return Column(
      children: [
        Builder(
          builder: ((context) {
            gestorProvider.todosCuidadores();
            return Expanded(
              child: ListView.builder(
                itemCount: gestorProvider.cuidadores.length,
                itemBuilder: (context, index) {
                  if (gestorProvider.cuidadores.isEmpty) {
                    return const Text('nenhum cuidador cadastrado');
                  } else {
                    return ItemContainer(
                      title: gestorProvider.cuidadores[index].nome,
                      subtitle: gestorProvider.cuidadores[index].sobrenome,
                      onTap: () {
                        context.read<CuidadorProvider>().cuidador =
                            gestorProvider.cuidadores[index];
                        Navigator.of(context).push(
                          AnimatedPageTransition(
                            page: const CadastroCuidador(),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            );
          }),
        ),
        SizedBox(
          height: 50,
          child: Center(
            child: BotaoCadastro(
              onPressed: () {
                context.read<CuidadorProvider>().cuidador = Cuidador();
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
    final GestorProvider gestorProvider = Provider.of<GestorProvider>(context);
    return Column(
      children: <Widget>[
        Expanded(
          child: Builder(builder: (context) {
            gestorProvider.todosClientes();
            if (gestorProvider.clientes.isEmpty) {
              return const Text('nenhum cliente cadastrado');
            } else {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: gestorProvider.clientes.length,
                itemBuilder: (context, index) {
                  return ItemContainer(
                    onTap: () {
                      context.read<ResponsavelProvider>().responsavel =
                          gestorProvider.clientes[index];
                      Navigator.push(
                        context,
                        AnimatedPageTransition(
                          page: const CadastroResponsavel(),
                        ),
                      );
                    },
                    title: gestorProvider.clientes[index].nome,
                  );
                },
              );
            }
          }),
        ),
        SizedBox(
          height: 50,
          child: BotaoCadastro(
            onPressed: () {
              context.read<ResponsavelProvider>().responsavel = Responsavel();
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
