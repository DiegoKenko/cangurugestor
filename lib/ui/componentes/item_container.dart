import 'package:cangurugestor/ui/componentes/styles.dart';
import 'package:flutter/material.dart';

class ItemContainer extends StatelessWidget {
  final String titulo;
  final String subtitle;
  const ItemContainer({
    Key? key,
    this.titulo = '',
    this.subtitle = '',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: corPad1.withOpacity(0.4),
        ),
        width: MediaQuery.of(context).size.width / 0.6,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: Column(
          children: [
            Center(
              child: Text(
                (titulo).toUpperCase(),
                style: kNameStyle,
              ),
            ),
            subtitle != ''
                ? const SizedBox(
                    height: 10,
                  )
                : Container(),
            subtitle != ''
                ? Center(
                    child: Text(
                      subtitle,
                      style: kNameStyle,
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
