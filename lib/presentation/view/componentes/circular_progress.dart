import 'package:cangurugestor/presentation/view/componentes/styles.dart';
import 'package:flutter/material.dart';

class CircularProgressCanguru extends StatelessWidget {
  const CircularProgressCanguru({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 100,
      width: double.infinity,
      child: Column(
        children: [
          CircularProgressIndicator(
            color: corPad1,
            strokeWidth: 10,
            backgroundColor: corBranco,
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Carregando...',
              style: TextStyle(color: corPad1),
            ),
          ),
        ],
      ),
    );
  }
}
