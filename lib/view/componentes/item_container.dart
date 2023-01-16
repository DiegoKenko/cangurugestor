import 'package:cangurugestor/view/componentes/styles.dart';
import 'package:flutter/material.dart';

class ItemContainer extends StatelessWidget {
  final String title;
  final String subtitle;
  final Function()? onTap;
  const ItemContainer({
    Key? key,
    this.title = '',
    this.subtitle = '',
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: ListTile(
          subtitle: Text(subtitle),
          title: Text(
            title,
          ),
        ),
      ),
    );
  }
}
