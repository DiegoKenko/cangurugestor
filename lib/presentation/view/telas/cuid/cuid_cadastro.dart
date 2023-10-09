import 'package:cangurugestor/const/global.dart';
import 'package:cangurugestor/domain/entity/cuidador_entity.dart';
import 'package:cangurugestor/presentation/state/cuidador_state.dart';
import 'package:cangurugestor/presentation/view/componentes/dialog_confirmacao_exclusao.dart';
import 'package:cangurugestor/presentation/view/componentes/styles.dart';
import 'package:cangurugestor/presentation/view/componentes/tab.dart';
import 'package:cangurugestor/presentation/controller/cuidador_controller.dart';
import 'package:cangurugestor/presentation/view/telas/cuid/widget/cuid_dados.dart';
import 'package:flutter/material.dart';

class CadastroCuidador extends StatefulWidget {
  const CadastroCuidador({
    Key? key,
    required this.cuidador,
  }) : super(key: key);
  final CuidadorEntity cuidador;

  @override
  State<CadastroCuidador> createState() => _CadastroCuidadorState();
}

class _CadastroCuidadorState extends State<CadastroCuidador>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final CuidadorController cuidadorController = getIt.get<CuidadorController>();

  @override
  void initState() {
    _tabController = TabController(length: 1, vsync: this, initialIndex: 0);
    _tabController.addListener(() {});

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: cuidadorController,
      builder: (context, state, _) {
        CuidadorEntity cuidador = CuidadorEntity();
        if (state is CuidadorSuccessState) {
          cuidador = state.cuidador;
        }
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                if (cuidador.nome.isEmpty) {
                  Navigator.of(context).pop();
                  return;
                }

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
                  cuidador.nome.toUpperCase(),
                  style: kTitleAppBarStyle,
                ),
                Text(
                  'cuidador',
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
              ],
              views: const [
                Tab(
                  child: DadosCuidador(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
