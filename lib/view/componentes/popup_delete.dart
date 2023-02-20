import 'package:flutter/material.dart';

showPopupDelete(BuildContext context, Function() onConfirm) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return PopupDelete(onConfirm: onConfirm);
    },
  );
}

class PopupDelete extends StatelessWidget {
  final Function() onConfirm;

  const PopupDelete({Key? key, required this.onConfirm}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const String content = 'Deseja realmente excluir este item?';
    return AlertDialog(
      content: const Text(content),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancelar'),
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
          },
        ),
        TextButton(
          onPressed: () {
            onConfirm;
          },
          child: const Text('Excluir'),
        ),
      ],
    );
  }
}
