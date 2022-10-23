import 'package:cangurugestor/ui/componentes/styles.dart' show kInputStyle;
import 'package:flutter/material.dart';

class HeaderCadastro extends StatelessWidget {
  String? texto;
  HeaderCadastro({Key? key, this.texto}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: Text(
          texto ?? '',
          style: kInputStyle,
        ),
      ),
    );
  }
}
