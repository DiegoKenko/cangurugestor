import 'package:cangurugestor/view/componentes/drawer.dart';
import 'package:cangurugestor/view/componentes/styles.dart';
import 'package:cangurugestor/view/componentes/tab.dart';
import 'package:cangurugestor/viewModel/provider_cuidador.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PainelCuidador extends StatefulWidget {
  const PainelCuidador({Key? key}) : super(key: key);

  @override
  State<PainelCuidador> createState() => _PainelCuidadorState();
}

class _PainelCuidadorState extends State<PainelCuidador>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final CuidadorProvider cuidadorProvider = context.watch<CuidadorProvider>();
    return Scaffold(
      drawer: const CanguruDrawer(),
      appBar: AppBar(
        backgroundColor: corPad1,
        title: Column(
          children: [
            Text(cuidadorProvider.cuidador.nome, style: kTitleAppBarStyle),
            Text('cuidador', style: kSubtitleAppBarStyle),
          ],
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: TabCanguru(
          controller: _tabController,
          tabs: const [
            Tab(
              text: 'Pacientes',
            ),
            Tab(
              text: 'Tarefas',
            ),
          ],
          views: [
            Tab(
              child: Container(),
            ),
            Tab(
              child: Container(),
            ),
          ],
        ),
      ),
    );
  }
}
