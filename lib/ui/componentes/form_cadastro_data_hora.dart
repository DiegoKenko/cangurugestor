import 'package:cangurugestor/ui/componentes/form_cadastro_data.dart';
import 'package:cangurugestor/ui/componentes/form_cadastro_hora.dart';
import 'package:flutter/material.dart';

class FormCadastroDataHora extends StatelessWidget {
  final TextEditingController controllerHora;
  final TextEditingController controllerData;
  final void Function(DismissDirection)? onDismissed;
  final bool enabled;
  const FormCadastroDataHora(
      {required Key? key,
      this.enabled = true,
      required this.controllerHora,
      required this.controllerData,
      required this.onDismissed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      onDismissed: onDismissed,
      background: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Icon(
              Icons.delete,
              color: Colors.red,
            ),
          ),
          Expanded(
            child: Container(),
            flex: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Icon(
              Icons.delete,
              color: Colors.red,
            ),
          ),
        ],
      ),
      key: key!,
      child: Row(
        children: [
          Flexible(
            flex: 5,
            child: FormCadastroData(
              controller: controllerData,
              labelText: '',
              enabled: enabled,
              dataInicial: DateTime.now(),
              dataUltima: DateTime(
                DateTime.now().year + 1,
              ),
              dataPrimeira: DateTime.now(),
            ),
          ),
          Flexible(
            flex: 4,
            child: FormCadastroHora(
              controller: controllerHora,
              labelText: '',
              enabled: enabled,
            ),
          ),
        ],
      ),
    );
  }
}
