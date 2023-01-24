import 'package:cangurugestor/view/componentes/styles.dart';
import 'package:flutter/material.dart';

class ItemContainer extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget? trailing;
  final Function()? onTap;
  const ItemContainer({
    Key? key,
    this.title = '',
    this.subtitle = '',
    this.onTap,
    this.trailing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Card(
        shadowColor: corPad1,
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: InkWell(
          onTap: onTap,
          child: ListTile(
            trailing: trailing,
            subtitle: Text(subtitle),
            title: Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: corPad1,
                    width: 1,
                  ),
                ),
              ),
              child: Text(
                title,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
