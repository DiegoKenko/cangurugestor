import 'package:cangurugestor/classes/consulta.dart';
import 'package:cangurugestor/ui/componentes/item_container.dart';
import 'package:flutter/material.dart';

class ItemConsulta extends StatefulWidget {
  Consulta consulta;
  void Function()? onTap;
  ItemConsulta({Key? key, required this.consulta, this.onTap})
      : super(key: key);

  @override
  State<ItemConsulta> createState() => _ItemConsultaState();
}

class _ItemConsultaState extends State<ItemConsulta> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: ItemContainer(
        titulo: widget.consulta.nome,
        subtitle: widget.consulta.descricao,
      ),
    );
  }
}
