import 'package:cangurugestor/classes/atividade.dart';
import 'package:cangurugestor/ui/componentes/item_container.dart';
import 'package:flutter/material.dart';

class ItemAtividade extends StatefulWidget {
  Atividade atividade;
  void Function()? onTap;
  ItemAtividade({Key? key, required this.atividade, this.onTap})
      : super(key: key);

  @override
  State<ItemAtividade> createState() => _ItemAtividadeState();
}

class _ItemAtividadeState extends State<ItemAtividade> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: ItemContainer(
        titulo: widget.atividade.nome!,
        subtitle: Text(widget.atividade.descricao),
      ),
    );
  }
}
