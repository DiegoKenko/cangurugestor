import 'package:cangurugestor/view/componentes/styles.dart';
import 'package:flutter/material.dart';

class FormDropDown extends StatefulWidget {
  final List<String> lista;
  final TextEditingController? controller;
  final String value;
  final String hintText;
  final InputBorder? borda = const OutlineInputBorder();
  const FormDropDown(
      {Key? key,
      required this.lista,
      required this.controller,
      required this.value,
      required this.hintText})
      : super(key: key);

  @override
  State<FormDropDown> createState() => _FormDropDownState();
}

class _FormDropDownState extends State<FormDropDown> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 20, bottom: 10, top: 10),
      padding: const EdgeInsets.only(left: 20),
      width: MediaQuery.of(context).size.width * 0.8,
      decoration: kBoxDecorationDropDown,
      child: DropdownButtonFormField<String>(
        isExpanded: true,
        borderRadius: BorderRadius.circular(20),
        value: null,
        hint: Text(widget.hintText),
        icon: const Icon(Icons.arrow_downward),
        style: kTextStyleHeader,
        onChanged: (String? value) {},
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
