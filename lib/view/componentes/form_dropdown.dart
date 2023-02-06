import 'package:cangurugestor/view/componentes/styles.dart';
import 'package:flutter/material.dart';

class FormDropDown extends StatefulWidget {
  final List<String> lista;
  final TextEditingController? controller;
  final String value;
  final String hintText;
  final InputBorder? borda = const OutlineInputBorder();
  const FormDropDown({
    Key? key,
    required this.lista,
    required this.controller,
    required this.value,
    required this.hintText,
  }) : super(key: key);

  @override
  State<FormDropDown> createState() => _FormDropDownState();
}

class _FormDropDownState extends State<FormDropDown> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: DropdownButtonFormField<String>(
        isExpanded: true,
        value: widget.value,
        hint: Text(widget.hintText),
        icon: const Icon(
          Icons.arrow_downward,
          size: 20,
        ),
        style: kLabelStyle,
        onChanged: (String? value) {
          widget.controller!.text = value!;
        },
        items: widget.lista.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }
}
