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
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 40),
        child: Align(
          alignment: Alignment.center,
          child: Container(
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              border: Border.all(
                //color: corPad1,
                color: Theme.of(context).splashColor,

                width: 2,
              ),
              color: Colors.transparent,
            ),
            width: 50,
            height: 35,
            child: const Center(
              child: Icon(
                Icons.add,
                size: 30,
                //color: Theme.of(context).splashColor,
                color: corPad1,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
