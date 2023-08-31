import 'package:cangurugestor/const/global.dart';
import 'package:cangurugestor/domain/entity/gestor_entity.dart';
import 'package:cangurugestor/presentation/controller/gestor_controller.dart';
import 'package:cangurugestor/presentation/state/gestor_state.dart';
import 'package:cangurugestor/presentation/view/componentes/drawer.dart';
import 'package:cangurugestor/presentation/view/componentes/styles.dart';
import 'package:cangurugestor/presentation/view/componentes/tab.dart';
import 'package:cangurugestor/presentation/view/telas/gest/widget/gest_clientes.dart';
import 'package:cangurugestor/presentation/view/telas/gest/widget/gest_cuidadores.dart';
import 'package:flutter/material.dart';

class PainelGestor extends StatefulWidget {
  const PainelGestor({Key? key, required this.gestor}) : super(key: key);
  final GestorEntity gestor;

  @override
  State<PainelGestor> createState() => _PainelGestorState();
}

class _PainelGestorState extends State<PainelGestor>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final GestorController gestorController = getIt<GestorController>();

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    gestorController.load(widget.gestor);
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
