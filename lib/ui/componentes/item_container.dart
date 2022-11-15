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
      child: Material(
        shadowColor: corPad1.withOpacity(0.3),
        color: corPad1.withOpacity(0.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 20,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
      ),
    );
  }
}
