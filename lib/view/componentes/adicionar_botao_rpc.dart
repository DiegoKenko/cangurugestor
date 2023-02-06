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
        width: MediaQuery.of(context).size.width * 0.5,
        decoration: BoxDecoration(
          border: Border.all(
            color: corPad1,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(50),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.1,
            ),
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
