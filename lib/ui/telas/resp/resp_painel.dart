import 'package:cangurugestor/classes/responsavel.dart';
import 'package:cangurugestor/ui/componentes/agrupador_cadastro.dart';
import 'package:cangurugestor/ui/componentes/header_cadastro.dart';
import 'package:cangurugestor/ui/componentes/styles.dart';
import 'package:flutter/material.dart';

class PainelResponsavel extends StatefulWidget {
  final Responsavel responsavel;
  const PainelResponsavel({Key? key, required this.responsavel})
      : super(key: key);

  @override
  State<PainelResponsavel> createState() => _PainelResponsavelState();
}

class _PainelResponsavelState extends State<PainelResponsavel> {
  List<Widget> pacientesWidgets = [];
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
                texto: 'Bem-vindo ${widget.responsavel.nome}!',
              ),
              AgrupadorCadastro(
                leading: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.notifications,
                    size: 40,
                    color: corPad1,
                  ),
                ),
                titulo: 'Notificações',
                children: const [],
              ),
              AgrupadorCadastro(
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
                  titulo: 'Pacientes',
                  children: pacientesWidgets),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
