import 'package:cangurugestor/model/responsavel.dart';
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
      bottomNavigationBar: const BottomAppBar(
        color: corPad1,
        child: SizedBox(
          height: 50,
          child: Center(),
        ),
      ),
      body: SafeArea(
        child: TabCanguru(
          controller: _tabController,
          tabs: [
            Tab(
              child: Text(
                'Responsáveis',
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
                      gestorProvider.allCostumers();
                      if (gestorProvider.costumers.isEmpty) {
                        return Container();
                      } else {
                        return ListView(
                          shrinkWrap: true,
                          children: gestorProvider.costumers.map((resp) {
                            return ItemContainer(
                              onTap: () {
                                context
                                    .read<ResponsavelProvider>()
                                    .setResponsavel(resp);
                                Navigator.push(
                                  context,
                                  AnimatedPageTransition(
                                    page: const CadastroResponsavel(),
                                  ),
                                );
                              },
                              title: resp.nome,
                            );
                          }).toList(),
                        );
                      }
                    }),
                  ),
                  SizedBox(
                    height: 50,
                    child: IconButton(
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
                      icon: const Icon(
                        Icons.add,
                      ),
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
