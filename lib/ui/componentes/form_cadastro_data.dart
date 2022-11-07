// ignore_for_file: body_might_complete_normally_nullable

import 'package:cangurugestor/ui/componentes/styles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FormCadastroData extends StatefulWidget {
  final TextEditingController controller;
  final TextInputType textInputType;
  final IconData? icon;
  final String? hintText;
  final String labelText;
  final bool obrigatorio;
  DateTime dataUltima = DateTime(DateTime.now().year + 50);
  DateTime dataPrimeira = DateTime(DateTime.now().year - 50);
  DateTime dataInicial = DateTime.now();
  bool? enabled;
  FormCadastroData(
      {Key? key,
      required this.controller,
      required this.labelText,
      required this.enabled,
      required this.dataInicial,
      required this.dataUltima,
      required this.dataPrimeira,
      this.obrigatorio = false,
      this.hintText,
      this.icon,
      this.textInputType = TextInputType.none})
      : super(key: key);

  @override
  State<FormCadastroData> createState() => _FormCadastroDataState();
}

class _FormCadastroDataState extends State<FormCadastroData> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: widget.obrigatorio
          ? (p0) {
              if (p0!.isEmpty) {
                return 'Campo obrigatório';
              }
            }
          : null,
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
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
            context: context,
            initialDate: widget.dataInicial,
            firstDate: widget.dataPrimeira,
            lastDate: widget.dataUltima);
        if (pickedDate != null) {
          String formattedDate = DateFormat('dd/MM/yyyy').format(pickedDate);
          setState(() {
            widget.controller.text =
                formattedDate; //set output date to TextField value.
          });
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
    );
  }
}
