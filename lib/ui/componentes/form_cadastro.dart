// ignore_for_file: body_might_complete_normally_nullable

import 'package:cangurugestor/ui/componentes/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FormCadastro extends StatefulWidget {
  final TextEditingController controller;
  final TextInputType textInputType;
  final List<TextInputFormatter>? inputFormatters;
  final IconData? icon;
  final String? hintText;
  final String labelText;
  final bool enabled;
  final bool multiLine;
  final bool obrigatorio;
  Function? onTap;
  InputBorder? borda = const OutlineInputBorder();
  FormCadastro(
      {Key? key,
      required this.controller,
      required this.labelText,
      this.enabled = false,
      this.hintText,
      this.icon,
      this.obrigatorio = false,
      this.onTap,
      this.multiLine = false,
      this.inputFormatters,
      this.borda = const OutlineInputBorder(),
      this.textInputType = TextInputType.none})
      : super(key: key);

  @override
  State<FormCadastro> createState() => _FormCadastroState();
}

class _FormCadastroState extends State<FormCadastro> {
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
        onTap: widget.onTap as void Function()?,
        maxLines: widget.multiLine ? 5 : 1,
        inputFormatters: widget.inputFormatters,
        enabled: widget.enabled,
        cursorWidth: 2,
        toolbarOptions: const ToolbarOptions(),
        cursorColor: corPreto,
        controller: widget.controller,
        keyboardType: widget.textInputType,
        style: kInputStyle2,
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: const TextStyle(color: corPad1),
          label: Text(widget.labelText.toUpperCase()),
          labelStyle: kLabelStyle,
          focusColor: Colors.white,
          border: widget.borda,
        ),
      ),
    );
  }
}
