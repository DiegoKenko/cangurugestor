import 'package:cangurugestor/view/componentes/styles.dart'
    show kTextStyleHeader;
import 'package:flutter/material.dart';

class HeaderCadastro extends StatelessWidget {
  final String texto;
  const HeaderCadastro({
    Key? key,
    required this.texto,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: Text(
          texto,
          style: kTextStyleHeader,
        ),
      ),
    );
  }
}
