import 'package:cangurugestor/classes/gestor.dart';
import 'package:cangurugestor/ui/componentes/adicionar_botao_rpc.dart';
import 'package:cangurugestor/ui/componentes/agrupador_cadastro.dart';
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
  }

  @override
  State<PainelGestor> createState() => _PainelGestorState();
}

class _PainelGestorState extends State<PainelGestor> {
  Future<List> todosResponsaveis = Future.value([]);
  List<Widget> clienteWidget = [];

  @override
  void initState() {
    clienteWidget = [];
    clienteWidget = List<Widget>.from(
      widget.gestor.clientes.map(
        (responsavel) {
          return ItemResponsavel(
            privilegio: global.privilegioGestor,
            responsavel: responsavel,
          );
        },
      ),
    );
    clienteWidget.add(
      BotaoCadastro(
        onPressed: () {
          final result = Navigator.push(
            context,
            MaterialPageRoute(builder: (context) {
              return CadastroResponsavel(
                privilegio: global.privilegioGestor,
                opcao: global.opcaoInclusao,
              );
            }),
          );
          result.then((value) {
            if (value != null) {
              setState(() {
                widget.gestor.clientes.add(value);
                clienteWidget.insert(
                  0,
                  ItemResponsavel(
                    responsavel: value,
                    privilegio: global.privilegioGestor,
                  ),
                );
              });
            }
          });
        },
      ),
    );
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
                texto: 'Bem-vindo ${widget.gestor.nome}!',
              ),
              AgrupadorCadastro(
                  initiallyExpanded: true,
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
                  children: clienteWidget),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
