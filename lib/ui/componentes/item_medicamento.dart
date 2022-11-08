import 'package:cangurugestor/classes/medicamentos.dart';
import 'package:cangurugestor/ui/componentes/item_container.dart';
import 'package:flutter/material.dart';

class ItemMedicamento extends StatefulWidget {
  Medicamento medicamento;
  void Function()? onTap;
  ItemMedicamento({Key? key, required this.medicamento, this.onTap})
      : super(key: key);

  @override
  State<ItemMedicamento> createState() => _ItemMedicamentoState();
}

class _ItemMedicamentoState extends State<ItemMedicamento> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: ItemContainer(
        titulo: widget.medicamento.nome,
        subtitle: widget.medicamento.descricao,
      ),
    );
  }
}
