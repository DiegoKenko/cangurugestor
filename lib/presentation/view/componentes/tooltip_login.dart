import 'package:cangurugestor/presentation/view/componentes/styles.dart';
import 'package:flutter/material.dart';

class TooltipClassePessoa extends StatelessWidget {
  const TooltipClassePessoa({
    super.key,
    required this.tip,
    required this.title,
  });
  final String title;
  final String tip;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      textStyle: const TextStyle(fontSize: 15, color: corBranco),
      decoration: BoxDecoration(
        color: corPad1,
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      showDuration: const Duration(seconds: 10),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
      triggerMode: TooltipTriggerMode.tap,
      message: tip,
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(
              Icons.info,
              color: corPad1,
              size: 18,
            ),
          ),
          Expanded(
            child: Text(title),
          ),
        ],
      ),
    );
  }
}
