import 'package:cangurugestor/classes/cuidador.dart';
import 'package:cangurugestor/ui/componentes/animated_page_transition.dart';
import 'package:cangurugestor/ui/componentes/item_container.dart';
import 'package:cangurugestor/ui/telas/cuid/cuid_cadastro.dart';
import 'package:flutter/material.dart';
import 'package:cangurugestor/global.dart' as global;

class ItemCuidador extends StatefulWidget {
  Cuidador cuidador;
  final int privilegio;
  ItemCuidador(
      {Key? key,
      required this.cuidador,
      this.privilegio = global.privilegioCuidador})
      : super(key: key);

  @override
  State<ItemCuidador> createState() => _ItemCuidadorState();
}

class _ItemCuidadorState extends State<ItemCuidador> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        var res = Navigator.of(context).push(
          AnimatedPageTransition(
            page: CadastroCuidador(
              privilegio: widget.privilegio,
              cuidador: widget.cuidador,
              opcao: global.opcaoAlteracao,
            ),
          ),
        );
        res.then((value) {
          if (value != null) {
            setState(() {
              widget.cuidador = value;
            });
          }
        });
      },
      child: ItemContainer(
        titulo: widget.cuidador.nome,
        subtitle: widget.cuidador.sobrenome,
      ),
    );
  }
}
