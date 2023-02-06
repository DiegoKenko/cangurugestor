import 'package:cangurugestor/model/activity.dart';
import 'package:cangurugestor/model/cuidador.dart';
import 'package:cangurugestor/view/componentes/styles.dart';
import 'package:cangurugestor/viewModel/provider_gestor.dart';
import 'package:cangurugestor/viewModel/provider_relatorio.dart';
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
    final GestorProvider gestorProvider = context.watch<GestorProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Relatório'),
      ),
      body: ChangeNotifierProvider(
        create: (context) =>
            RelatorioProviderGestor(gestor: gestorProvider.gestor),
        child: Padding(
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
              Expanded(
                child: Consumer<RelatorioProviderGestor>(
                  builder: (context, provider, _) {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: provider.cuidadores.length,
                      itemBuilder: (context, index) {
                        return ChangeNotifierProvider(
                          create: (context) => RelatorioProviderCuidador(
                            cuidador: provider.cuidadores[index],
                          ),
                          child: ExpansionCuidador(
                            cuidador: provider.cuidadores[index],
                          ),
                        );
                      },
                    );
                  },
                ),
              )
            ],
          ),
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
  final Cuidador cuidador;

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
    final RelatorioProviderCuidador provider =
        context.watch<RelatorioProviderCuidador>();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ExpansionTile(
        title: Text(provider.cuidador.nome),
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
          ...provider.logins
              .map(
                (LoginActivity e) =>
                    Text('${e.activityDate} as ${e.activityTime}'),
              )
              .toList(),
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
          ...provider.atendimentos
              .map(
                (TarefaActivity e) =>
                    Text('${e.activityDate} as ${e.activityTime}'),
              )
              .toList(),
        ],
        onExpansionChanged: (value) {
          if (value) {
            provider.load();
          }
        },
      ),
    );
  }
}
