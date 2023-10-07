import 'package:cangurugestor/const/global.dart';
import 'package:cangurugestor/domain/entity/responsavel_entity.dart';
import 'package:cangurugestor/presentation/controller/responsavel_controller.dart';
import 'package:cangurugestor/presentation/view/componentes/dialog_confirmacao_exclusao.dart';
import 'package:cangurugestor/presentation/view/componentes/styles.dart';
import 'package:cangurugestor/presentation/view/componentes/tab.dart';
import 'package:cangurugestor/presentation/view/telas/resp/widget/resp_dados.dart';
import 'package:cangurugestor/presentation/view/telas/resp/widget/resp_pacientes.dart';
import 'package:flutter/material.dart';

class CadastroResponsavel extends StatefulWidget {
  const CadastroResponsavel({Key? key, required this.responsavel})
      : super(key: key);
  final ResponsavelEntity responsavel;

  @override
  State<CadastroResponsavel> createState() => _CadastroResponsavelState();
}

class _CadastroResponsavelState extends State<CadastroResponsavel>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ResponsavelController _responsavelController =
      getIt<ResponsavelController>();

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    _responsavelController.init(widget.responsavel);
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
            _responsavelController.update();
            Navigator.of(context).pop();
          },
        ),
        actions: [
          widget.responsavel.id.isNotEmpty
              ? IconButton(
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
                )
              : Container(),
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
          views: [
            Tab(
              child: DadosResponsavel(
                responsavelController: _responsavelController,
              ),
            ),
            Tab(
              child: PacientesResponsavel(
                responsavelController: _responsavelController,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
