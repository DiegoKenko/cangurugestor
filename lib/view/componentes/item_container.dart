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
    return Card(
      child: InkWell(
        onTap: onTap,
        child: ListTile(
          trailing: trailing,
          subtitle: Text(subtitle),
          title: Text(
            title,
          ),
        ),
      ),
    );
  }
}
