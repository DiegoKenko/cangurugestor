// ignore_for_file: body_might_complete_normally_nullable

import 'package:cangurugestor/view/componentes/styles.dart';
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
  final Function? onTap;
  final Function(String)? onChanged;
  final Function()? onEditingComplete;
  const FormCadastro(
      {Key? key,
      required this.controller,
      required this.labelText,
      this.onEditingComplete,
      this.onChanged,
      this.enabled = false,
      this.hintText,
      this.icon,
      this.obrigatorio = false,
      this.onTap,
      this.multiLine = false,
      this.inputFormatters,
      required this.textInputType})
      : super(key: key);

  @override
  State<FormCadastro> createState() => _FormCadastroState();
}

class _FormCadastroState extends State<FormCadastro> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: TextFormField(
        onChanged: widget.onChanged,
        onEditingComplete: widget.onEditingComplete,
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
        style: kTextStyleHeader,
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: const TextStyle(color: corPad1),
          label: Text(widget.labelText.toUpperCase()),
          labelStyle: kLabelStyle,
          focusColor: Colors.white,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
