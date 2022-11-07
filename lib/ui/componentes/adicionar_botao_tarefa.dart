import 'package:cangurugestor/ui/componentes/styles.dart';
import 'package:flutter/material.dart';

class BotaoCadastroTarefa extends StatefulWidget {
  final Function() onPressed;
  const BotaoCadastroTarefa({Key? key, required this.onPressed})
      : super(key: key);

  @override
  State<BotaoCadastroTarefa> createState() => _BotaoCadastroTarefaState();
}

class _BotaoCadastroTarefaState extends State<BotaoCadastroTarefa> {
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
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color: corPad1,
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
                color: corPad2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
