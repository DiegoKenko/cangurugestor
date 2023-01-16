import 'package:cangurugestor/view/componentes/form_cadastro_data.dart';
import 'package:cangurugestor/view/componentes/form_cadastro_hora.dart';
import 'package:flutter/material.dart';

class FormCadastroDataHora extends StatelessWidget {
  final TextEditingController controllerHora;
  final TextEditingController controllerData;
  final void Function(DismissDirection)? onDismissed;
  final void Function(DateTime date)? onDateChanged;
  final void Function(TimeOfDay time)? onTimeChanged;

  final bool enabled;
  const FormCadastroDataHora(
      {Key? key,
      this.enabled = true,
      this.onDateChanged,
      this.onTimeChanged,
      required this.controllerHora,
      required this.controllerData,
      required this.onDismissed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          flex: 5,
          child: FormCadastroData(
            onDateChanged: onDateChanged,
            controller: controllerData,
            labelText: '',
            enabled: enabled,
            dataInicial: DateTime.now(),
            dataUltima: DateTime(
              DateTime.now().year + 1,
              DateTime.now().month + 12,
            ),
            dataPrimeira: DateTime.now(),
          ),
        ),
        Flexible(
          flex: 4,
          child: FormCadastroHora(
            onTimeChanged: onTimeChanged,
            controller: controllerHora,
            labelText: '',
            enabled: enabled,
          ),
        ),
      ],
    );
  }
}
