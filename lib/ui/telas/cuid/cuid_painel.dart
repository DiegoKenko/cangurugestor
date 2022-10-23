import 'package:cangurugestor/classes/cuidador.dart';
import 'package:cangurugestor/firebaseUtils/firestore_funcoes.dart';
import 'package:cangurugestor/global.dart';
import 'package:cangurugestor/ui/componentes/agrupador_cadastro.dart';
import 'package:cangurugestor/ui/componentes/header_cadastro.dart';
import 'package:cangurugestor/ui/componentes/item_tarefa.dart';
import 'package:cangurugestor/ui/componentes/styles.dart';
import 'package:flutter/material.dart';
import 'package:cangurugestor/global.dart' as global;

class PainelCuidador extends StatefulWidget {
  final Cuidador cuidador;
  final int privilegio = global.privilegioCuidador;
  PainelCuidador({
    Key? key,
    required this.cuidador,
  }) : super(key: key) {
    global.cuidadorAtual = cuidador;
    global.idResponsavelGlobal = cuidador.idResponsavel ?? '';
    global.idCuidadorGlobal = cuidador.id;
  }

  @override
  State<PainelCuidador> createState() => _PainelCuidadorState();
}

class _PainelCuidadorState extends State<PainelCuidador> {
  Future<List> todosPacientes = Future.value([]);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        backgroundColor: corPad1.withOpacity(0.8),
      ),
      appBar: AppBar(
        actions: const [],
        backgroundColor: corPad1,
      ),
      bottomNavigationBar: BottomAppBar(
        color: corPad1,
        child: Container(
          height: 50,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              HeaderCadastro(
                texto: 'Bem-vindo ${widget.cuidador.nome}!',
              ),
              const SizedBox(
                height: 20,
              ),
              FutureBuilder(
                  future: pacientesCuidador(),
                  builder: (context,
                      AsyncSnapshot<List<AgrupadorCadastro>> builder) {
                    if (builder.hasData) {
                      if (builder.data != null) {
                        return Column(
                          children: builder.data!,
                        );
                      } else {
                        return const Center(
                          child: Text('Nenhum paciente cadastrado'),
                        );
                      }
                    }
                    return const Center(
                      child: Text('Nenhum paciente cadastrado'),
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }

  Future<List<AgrupadorCadastro>> pacientesCuidador() async {
    List<Widget> tarefasWidget = [];
    List<AgrupadorCadastro> pacientesWidget = [];

    var pacientes = await MeuFirestore()
        .todosPacientesCuidador(global.idResponsavelGlobal, widget.cuidador.id);

    for (var paciente in pacientes) {
      var tarefas = await MeuFirestore.todasTarefasPaciente(
          paciente.id, EnumTarefa.medicamento);
      tarefasWidget = [];
      for (var tarefa in tarefas) {
        tarefasWidget.add(ItemTarefa(
          tarefa: tarefa,
          onTap: () {},
        ));
      }
      pacientesWidget.add(AgrupadorCadastro(
        leading: const Icon(
          Icons.person,
          color: corPad1,
        ),
        titulo: paciente.nome,
        children: tarefasWidget,
      ));
    }

    return pacientesWidget;
  }
}
