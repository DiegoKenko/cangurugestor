import 'package:cangurugestor/view/componentes/styles.dart';
import 'package:flutter/material.dart';

class DialogConfirmacaoExclusao extends StatelessWidget {
  const DialogConfirmacaoExclusao({super.key, required this.onConfirm});
  final Function onConfirm;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(10),
        height: 100,
        width: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              'Deseja realmente excluir os dados? Essa ação não poderá ser desfeita.',
              style: kTitleDescription,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  child: Text(
                    'EXCLUIR',
                    style: kTitleDescription.copyWith(
                      fontSize: 14,
                      color: Colors.red,
                    ),
                  ),
                  onTap: () {
                    onConfirm();
                    Navigator.of(context).pop();
                  },
                ),
                GestureDetector(
                  child: Text(
                    'CANCELAR',
                    style: kTitleDescription.copyWith(
                      fontSize: 14,
                      color: Colors.green,
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
