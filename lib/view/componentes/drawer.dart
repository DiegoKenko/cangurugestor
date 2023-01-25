import 'package:cangurugestor/view/componentes/animated_page_transition.dart';
import 'package:cangurugestor/view/componentes/styles.dart';
import 'package:cangurugestor/view/telas/tela_login.dart';
import 'package:cangurugestor/viewModel/provider_login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CanguruDrawer extends StatelessWidget {
  const CanguruDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: corPad1,
      child: Column(
        children: [
          Expanded(
            flex: 9,
            child: Container(),
          ),
          Expanded(
            flex: 1,
            child: DrawerListTile(
              title: const Text(
                'Sair',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                context.read<LoginProvider>().logout();
                Navigator.of(context).pushReplacement(
                  AnimatedPageTransition(
                    page: const TelaLogin(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    required this.title,
    required this.onTap,
  }) : super(key: key);
  final Widget title;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Colors.white,
              width: 1,
            ),
            bottom: BorderSide(
              color: Colors.white,
              width: 1,
            ),
          ),
        ),
        child: Center(
          child: ListTile(
            title: title,
            onTap: onTap,
          ),
        ),
      ),
    );
  }
}
