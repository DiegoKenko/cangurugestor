import 'package:cangurugestor/presentation/view/componentes/dialog_confirmacao_exclusao.dart';
import 'package:cangurugestor/presentation/view/componentes/styles.dart';
import 'package:cangurugestor/presentation/view/componentes/tab.dart';
import 'package:cangurugestor/presentation/view/telas/resp/widget/resp_dados.dart';
import 'package:cangurugestor/presentation/view/telas/resp/widget/resp_pacientes.dart';
import 'package:flutter/material.dart';

class CadastroResponsavel extends StatefulWidget {
  const CadastroResponsavel({
    Key? key,
  }) : super(key: key);

  @override
  State<CadastroResponsavel> createState() => _CadastroResponsavelState();
}

class _CadastroResponsavelState extends State<CadastroResponsavel>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return DialogConfirmacaoExclusao(
                    onConfirm: () {},
                  );
                },
              );
            },
          ),
        ],
        title: Column(
          children: [
            Text(
              '',
              style: kTitleAppBarStyle,
            ),
            Text(
              'cliente',
              style: kSubtitleAppBarStyle,
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: TabCanguru(
          controller: _tabController,
          tabs: const [
            Tab(
              child: Text(
                'Dados',
              ),
            ),
            Tab(
              child: Text(
                'Pacientes',
              ),
            ),
          ],
          views: const [
            Tab(
              child: DadosResponsavel(),
            ),
            Tab(child: PacientesResponsavel()),
          ],
        ),
      ),
    );
  }
}
