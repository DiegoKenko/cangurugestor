import 'package:cangurugestor/classes/gestor.dart';
import 'package:cangurugestor/classes/responsavel.dart';
import 'package:cangurugestor/firebaseUtils/fire_gestor.dart';
import 'package:cangurugestor/ui/componentes/adicionar_botao_rpc.dart';
import 'package:cangurugestor/ui/componentes/agrupador_cadastro.dart';
import 'package:cangurugestor/ui/componentes/animated_page_transition.dart';
import 'package:cangurugestor/ui/componentes/header_cadastro.dart';
import 'package:cangurugestor/ui/componentes/item_responsavel.dart';
import 'package:cangurugestor/ui/componentes/styles.dart';
import 'package:cangurugestor/ui/telas/resp/resp_cadastro.dart';
import 'package:flutter/material.dart';
import 'package:cangurugestor/global.dart' as global;

class PainelGestor extends StatefulWidget {
  final Gestor gestor;

  PainelGestor({Key? key, required this.gestor}) : super(key: key) {
    global.gestorAtual = gestor;
    global.idGestorGlobal = gestor.id!;
  }

  @override
  State<PainelGestor> createState() => _PainelGestorState();
}

class _PainelGestorState extends State<PainelGestor> {
  List<Widget> clienteWidget = [];
  final FirestoreGestor firestoreGestor = FirestoreGestor();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*  drawer: Drawer(
        backgroundColor: corPad1.withOpacity(0.8),
      ), */
      appBar: AppBar(
        leading: Container(),
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
                texto: 'Bem-vindo ${widget.gestor.nome}!',
              ),
              StreamBuilder(
                  stream:
                      firestoreGestor.todosClientesGestor(widget.gestor.id!),
                  builder: (context, AsyncSnapshot<List<Responsavel>> snap) {
                    clienteWidget = [];
                    if (snap.hasData) {
                      if (snap.data!.isNotEmpty) {
                        for (var i = 0; i < snap.data!.length; i++) {
                          clienteWidget.add(
                            ItemResponsavel(
                              privilegio: global.privilegioGestor,
                              responsavel: snap.data![i],
                            ),
                          );
                        }
                      }
                    }
                    clienteWidget.add(
                      BotaoCadastro(
                        onPressed: () {
                          Navigator.of(context).push(
                            AnimatedPageTransition(
                              page: CadastroResponsavel(
                                privilegio: global.privilegioGestor,
                                opcao: global.opcaoInclusao,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                    return AgrupadorCadastro(
                        leading: Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.person,
                            size: 40,
                            color: corPad1,
                          ),
                        ),
                        titulo: 'Clientes',
                        children: clienteWidget);
                  }),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
