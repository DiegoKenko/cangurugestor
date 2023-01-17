import 'package:cangurugestor/model/responsavel.dart';
import 'package:cangurugestor/view/componentes/adicionar_botao_rpc.dart';
import 'package:cangurugestor/view/componentes/animated_page_transition.dart';
import 'package:cangurugestor/view/componentes/drawer.dart';
import 'package:cangurugestor/view/componentes/item_container.dart';
import 'package:cangurugestor/view/componentes/styles.dart';
import 'package:cangurugestor/view/componentes/tab.dart';
import 'package:cangurugestor/view/telas/resp/resp_cadastro.dart';
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
    _tabController = TabController(length: 1, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final GestorProvider gestorProvider = Provider.of<GestorProvider>(context);

    return Scaffold(
      drawer: const CanguruDrawer(),
      appBar: AppBar(
        backgroundColor: corPad1,
      ),
      body: SafeArea(
        child: TabCanguru(
          controller: _tabController,
          tabs: [
            Tab(
              child: Text(
                'Clientes',
                style: kSubTituloStyle,
              ),
            )
          ],
          views: [
            Tab(
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Builder(builder: (context) {
                      gestorProvider.todosClientes();
                      if (gestorProvider.clientes.isEmpty) {
                        return Container();
                      } else {
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: gestorProvider.clientes.length,
                          itemBuilder: (context, index) {
                            return ItemContainer(
                              onTap: () {
                                context
                                    .read<ResponsavelProvider>()
                                    .setResponsavel(
                                        gestorProvider.clientes[index]);
                                Navigator.push(
                                  context,
                                  AnimatedPageTransition(
                                    page: const CadastroResponsavel(),
                                  ),
                                );
                              },
                              title: gestorProvider.clientes[index].nome,
                              subtitle: gestorProvider.clientes[index].id,
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
                        context
                            .read<ResponsavelProvider>()
                            .setResponsavel(Responsavel());
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
