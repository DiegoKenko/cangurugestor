import 'package:cangurugestor/classes/cuidador.dart';
import 'package:cangurugestor/classes/paciente.dart';
import 'package:cangurugestor/ui/componentes/animated_page_transition.dart';
import 'package:cangurugestor/ui/componentes/item_container.dart';
import 'package:cangurugestor/ui/telas/paci/paci_cadastro.dart';
import 'package:flutter/material.dart';
import 'package:cangurugestor/global.dart' as global;

class ItemPaciente extends StatefulWidget {
  Paciente paciente;
  final int privilegio;
  ItemPaciente({Key? key, required this.paciente, required this.privilegio})
      : super(key: key);

  @override
  State<ItemPaciente> createState() => _ItemPacienteState();
}

class _ItemPacienteState extends State<ItemPaciente> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .push(
          AnimatedPageTransition(
            page: CadastroPaciente(
              privilegio: widget.privilegio,
              paciente: widget.paciente,
              opcao: global.opcaoAlteracao,
            ),
          ),
        )
            .then((value) {
          setState(() {
            if (value != null) {
              widget.paciente = value;
            }
          });
        });
      },
      child: ItemContainer(
        titulo: widget.paciente.nome,
        subtitle: widget.paciente.sobrenome,
      ),
    );
  }

  void mostrarExclusao(TapDownDetails details) {
    final RenderBox referenceBox = context.findRenderObject() as RenderBox;
    final tapPosition = referenceBox.globalToLocal(details.globalPosition);
    IconButton exclusao =
        IconButton(onPressed: () {}, icon: const Icon(Icons.delete));
    final RenderObject? overlay =
        Overlay.of(context)?.context.findRenderObject();
    showMenu(
      context: context,
      items: [PopupMenuItem(child: exclusao)],
      position: RelativeRect.fromRect(
        Rect.fromLTWH(tapPosition.dx, tapPosition.dy, 30, 30),
        Rect.fromLTWH(0, 0, overlay!.paintBounds.size.width,
            overlay.paintBounds.size.height),
      ),
    );
  }
}
