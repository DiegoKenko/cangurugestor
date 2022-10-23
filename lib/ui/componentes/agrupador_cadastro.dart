import 'package:cangurugestor/ui/componentes/styles.dart';
import 'package:flutter/material.dart';

class AgrupadorCadastro extends StatefulWidget {
  final Widget leading;
  final List<Widget> children;
  final String titulo;
  final bool initiallyExpanded;
  const AgrupadorCadastro(
      {Key? key,
      required this.leading,
      required this.titulo,
      this.initiallyExpanded = true,
      required this.children})
      : super(key: key);

  @override
  State<AgrupadorCadastro> createState() => _AgrupadorCadastroState();
}

class _AgrupadorCadastroState extends State<AgrupadorCadastro> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 5,
        right: 20,
        left: 20,
        bottom: 20,
      ),
      child: Card(
        shadowColor: corPad1.withOpacity(0.5),
        elevation: 15,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: corPad1.withOpacity(0.2),
            borderRadius: const BorderRadius.all(
              Radius.circular(10),
            ),
            border: Border.all(
              color: corPad1,
              width: 1,
            ),
          ),
          child: Container(
            padding: const EdgeInsets.only(
              top: 10,
              left: 10,
              right: 10,
              bottom: 10,
            ),
            child: Center(
              child: Column(
                children: [
                  ExpansionTile(
                    collapsedIconColor: corPreto,
                    onExpansionChanged: (value) {},
                    iconColor: corPad1,
                    initiallyExpanded: widget.initiallyExpanded,
                    childrenPadding: const EdgeInsets.only(bottom: 10, top: 10),
                    leading: widget.leading,
                    title: Text(
                      widget.titulo.toUpperCase(),
                      style: const TextStyle(
                        color: corPreto,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                    children: widget.children,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
