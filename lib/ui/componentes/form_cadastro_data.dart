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
  final void Function(DateTime date)? onDateChanged;
  FormCadastroData(
      {Key? key,
      required this.controller,
      required this.labelText,
      required this.enabled,
      required this.dataInicial,
      required this.dataUltima,
      required this.dataPrimeira,
      this.onDateChanged,
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
                return null;
              }
            : null,
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
              builder: ((BuildContext context, Widget? child) {
                return Theme(
                  data: ThemeData.light().copyWith(
                    primaryColor: corPad1,
                    colorScheme: const ColorScheme.light(primary: corPad1),
                    buttonTheme: const ButtonThemeData(
                        textTheme: ButtonTextTheme.primary),
                  ),
                  child: child!,
                );
              }),
              context: context,
              initialDate: widget.dataInicial,
              firstDate: widget.dataPrimeira,
              lastDate: widget.dataUltima);
          if (pickedDate != null) {
            if (widget.onDateChanged != null) {
              widget.onDateChanged!(pickedDate);
            }
            widget.controller.text =
                DateFormat('dd/MM/yyyy').format(pickedDate);
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
