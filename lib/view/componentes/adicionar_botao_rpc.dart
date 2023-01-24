import 'package:cangurugestor/view/componentes/styles.dart';
import 'package:flutter/material.dart';

class BotaoCadastro extends StatefulWidget {
  final Function() onPressed;
  const BotaoCadastro({Key? key, required this.onPressed}) : super(key: key);

  @override
  State<BotaoCadastro> createState() => _BotaoCadastroState();
}

class _BotaoCadastroState extends State<BotaoCadastro> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: corPreto, width: 1),
            bottom: BorderSide(color: corPreto, width: 1),
          ),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.1),
            child: const Icon(
              Icons.add,
              size: 40,
              color: corPad1,
            ),
          ),
        ),
      ),
    );
  }
}
