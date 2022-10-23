import 'package:cangurugestor/ui/componentes/styles.dart';
import 'package:flutter/material.dart';

class ItemContainer extends StatelessWidget {
  final String titulo;
  final Widget? subtitle;
  final Widget? leading;
  final Image? image;
  const ItemContainer({
    Key? key,
    this.titulo = '',
    this.subtitle,
    this.leading,
    this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Material(
        shadowColor: corPad1.withOpacity(0.3),
        color: corPad1.withOpacity(0.7),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 20,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 20),
          child: ListTile(
            subtitle: subtitle,
            leading: leading,
            title: Text(
              (titulo).toUpperCase(),
              style: kNameStyle,
            ),
          ),
        ),
      ),
    );
  }
}
