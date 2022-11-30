import 'package:cangurugestor/ui/componentes/styles.dart'
    show kInputStyle2, kSubTituloStyle, kTituloStyle;
import 'package:flutter/material.dart';

class HeaderCadastro extends StatelessWidget {
  String? texto;
  String? titulo;
  String? subTitulo;
  HeaderCadastro({
    Key? key,
    required this.texto,
    this.titulo,
    this.subTitulo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 5),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 10),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: Text(
                titulo ?? '',
                style: kTituloStyle,
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 5, bottom: 5),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: Text(
                texto ?? '',
                style: kInputStyle2,
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 5, bottom: 30),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: Text(
                subTitulo ?? '',
                style: kSubTituloStyle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
