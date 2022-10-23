import 'package:cangurugestor/ui/componentes/styles.dart';
import 'package:flutter/material.dart';

class AppBarCan extends StatelessWidget with PreferredSizeWidget {
  final List<Widget> actions;
  final Widget leading;
  const AppBarCan({Key? key, required this.actions, required this.leading})
      : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: corPad1,
      leading: leading,
      actions: actions,
    );
  }
}
