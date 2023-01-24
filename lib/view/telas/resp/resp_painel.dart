import 'package:cangurugestor/view/componentes/drawer.dart';
import 'package:cangurugestor/view/componentes/styles.dart';
import 'package:cangurugestor/view/componentes/tab.dart';
import 'package:cangurugestor/viewModel/provider_responsavel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    final ResponsavelProvider responsavelProvider =
        context.watch<ResponsavelProvider>();
    return Scaffold(
      drawer: const CanguruDrawer(),
      appBar: AppBar(
        backgroundColor: corPad1,
        title: Column(
          children: [
            Text(responsavelProvider.responsavel.nome,
                style: kTitleAppBarStyle),
            Text('responsável', style: kSubtitleAppBarStyle),
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
              text: 'Contrato',
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
