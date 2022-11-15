import 'package:cangurugestor/classes/responsavel.dart';
import 'package:cangurugestor/ui/componentes/animated_page_transition.dart';
import 'package:cangurugestor/ui/componentes/item_container.dart';
import 'package:cangurugestor/ui/telas/resp/resp_cadastro.dart';
import 'package:flutter/material.dart';
import 'package:cangurugestor/global.dart' as global;

class ItemResponsavel extends StatefulWidget {
  Responsavel responsavel;
  final int privilegio;
  ItemResponsavel(
      {Key? key,
      required this.responsavel,
      this.privilegio = global.privilegioCuidador})
      : super(key: key);

  @override
  State<ItemResponsavel> createState() => _ItemResponsavelState();
}

class _ItemResponsavelState extends State<ItemResponsavel> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        var res = Navigator.of(context).push(
          AnimatedPageTransition(
            page: CadastroResponsavel(
              privilegio: widget.privilegio,
              responsavel: widget.responsavel,
              opcao: global.opcaoAlteracao,
            ),
          ),
        );
        res.then((value) {
          if (value != null) {
            setState(() {
              widget.responsavel = value;
            });
          }
        });
      },
      child: ItemContainer(
        titulo: widget.responsavel.nome,
        subtitle: widget.responsavel.sobrenome,
      ),
    );
  }
}