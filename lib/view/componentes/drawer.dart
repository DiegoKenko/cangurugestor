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
      backgroundColor: corPad1.withOpacity(0.8),
      child: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
          ListTile(
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
        ],
      ),
    );
  }
}
