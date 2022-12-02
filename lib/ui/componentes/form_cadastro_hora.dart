// ignore_for_file: body_might_complete_normally_nullable

import 'package:cangurugestor/ui/componentes/styles.dart';
import 'package:flutter/material.dart';

class FormCadastroHora extends StatefulWidget {
  final TextEditingController controller;
  final TextInputType textInputType;
  final IconData? icon;
  final String? hintText;
  final String labelText;
  final bool obrigatorio;
  bool? enabled;
  final void Function(TimeOfDay time)? onTimeChanged;
  FormCadastroHora(
      {Key? key,
      required this.controller,
      required this.labelText,
      required this.enabled,
      this.hintText,
      this.icon,
      this.onTimeChanged,
      this.obrigatorio = false,
      this.textInputType = TextInputType.none})
      : super(key: key);

  @override
  State<FormCadastroHora> createState() => _FormCadastroHoraState();
}

class _FormCadastroHoraState extends State<FormCadastroHora> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        left: 20,
      ),
      margin: const EdgeInsets.only(top: 10, bottom: 10),
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

          if (pickedTime != null) {
            widget.onTimeChanged!(pickedTime);
          }
        },
        enabled: widget.enabled,
        cursorWidth: 2,
        toolbarOptions: const ToolbarOptions(),
        cursorColor: corPad2,
        controller: widget.controller,
        keyboardType: widget.textInputType,
        style: kInputStyle2,
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
