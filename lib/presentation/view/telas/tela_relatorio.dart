import 'package:cangurugestor/const/global.dart';
import 'package:cangurugestor/domain/entity/activity_entity.dart';
import 'package:cangurugestor/domain/entity/cuidador_entity.dart';
import 'package:cangurugestor/presentation/state/relatorio_gestor_acesso_state.dart';
import 'package:cangurugestor/presentation/view/componentes/styles.dart';
import 'package:cangurugestor/presentation/controller/gestor_controller.dart';
import 'package:cangurugestor/presentation/controller/relatorio_gestor_acesso_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RelatorioTela extends StatefulWidget {
  const RelatorioTela({Key? key}) : super(key: key);

  @override
  State<RelatorioTela> createState() => _RelatorioTelaState();
}

class _RelatorioTelaState extends State<RelatorioTela> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Relatório'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  'Cuidadores',
                  style: kTituloStyleVerde,
                ),
              ),
            ),
            ValueListenableBuilder(
              valueListenable: getIt<RelatorioGestorAcessosController>(),
              builder: (context, state, _) {
                if (state is SuccessRelatorioGestorAcessoState) {
                  return Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: state.cuidadores.length,
                      itemBuilder: (context, index) {
                        return ExpansionCuidador(
                          cuidador: state.cuidadores[index],
                        );
                      },
                    ),
                  );
                }
                return Container();
              },
            )
          ],
        ),
      ),
    );
  }
}

class ExpansionCuidador extends StatefulWidget {
  const ExpansionCuidador({
    super.key,
    required this.cuidador,
  });
  final CuidadorEntity cuidador;

  @override
  State<ExpansionCuidador> createState() => _ExpansionCuidadorState();
}

class _ExpansionCuidadorState extends State<ExpansionCuidador>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ExpansionTile(
        title: Text(widget.cuidador.nome),
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                child: Text('Acessos', style: kSubtitleReportStyle),
              ),
            ),
          ),
          /*  ...provider.logins
              .map(
                (LoginActivity e) =>
                    Text('${e.activityDate} as ${e.activityTime}'),
              )
              .toList(), */
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                child: Text(
                  'Tarefas',
                  style: kSubtitleReportStyle,
                ),
              ),
            ),
          ),
          /*    ...provider.atendimentos
              .map(
                (TarefaActivity e) =>
                    Text('${e.activityDate} as ${e.activityTime}'),
              )
              .toList(), */
        ],
        onExpansionChanged: (value) {},
      ),
    );
  }
}
