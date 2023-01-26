// ignore_for_file: body_might_complete_normally_nullable

import 'package:cangurugestor/view/componentes/styles.dart';
import 'package:flutter/material.dart';

class FormCadastroHora extends StatefulWidget {
  final TextEditingController controller;
  final IconData? icon;
  final String? hintText;
  final String labelText;
  final bool obrigatorio;
  final bool enabled;
  final void Function(TimeOfDay time)? onTimeChanged;
  final Function(String)? onFieldSubmitted;
  const FormCadastroHora({
    Key? key,
    required this.controller,
    required this.labelText,
    required this.enabled,
    this.hintText,
    this.onFieldSubmitted,
    this.icon,
    required this.onTimeChanged,
    this.obrigatorio = false,
  }) : super(key: key);

  @override
  State<FormCadastroHora> createState() => _FormCadastroHoraState();
}

class _FormCadastroHoraState extends State<FormCadastroHora> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: TextFormField(
        validator: widget.obrigatorio
            ? (p0) {
                if (p0!.isEmpty) {
                  return 'Campo obrigatório';
                }
              }
            : null,
        onTap: () async {
          TimeOfDay? pickedTime = await showTimePicker(
            builder: ((BuildContext context, Widget? child) {
              return Theme(
                data: ThemeData.light().copyWith(
                  primaryColor: corPad1,
                  colorScheme: const ColorScheme.light(primary: corPad1),
                  buttonTheme:
                      const ButtonThemeData(textTheme: ButtonTextTheme.primary),
                ),
                child: child!,
              );
            }),
            helpText: 'Selecione a hora',
            initialEntryMode: TimePickerEntryMode.dialOnly,
            context: context,
            initialTime: TimeOfDay.now(),
          );

          if (pickedTime != null && widget.onTimeChanged != null) {
            widget.onTimeChanged!(pickedTime);
          }
        },
        onFieldSubmitted: widget.onFieldSubmitted,
        enabled: widget.enabled,
        cursorWidth: 2,
        cursorColor: corPad2,
        controller: widget.controller,
        style: kTextStyleHeader,
        decoration: InputDecoration(
          label: Text(widget.labelText.toUpperCase()),
          labelStyle: kLabelStyle,
          focusColor: Colors.white,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
