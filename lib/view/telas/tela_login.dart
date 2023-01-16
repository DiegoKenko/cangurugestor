import 'package:cangurugestor/autentication/auth_login.dart';
import 'package:cangurugestor/view/componentes/animated_page_transition.dart';
import 'package:cangurugestor/view/telas/gest/gest_painel.dart';
import 'package:cangurugestor/viewModel/provider_gestor.dart';
import 'package:cangurugestor/viewModel/provider_login.dart';
import 'package:flutter/material.dart';
import 'package:cangurugestor/view/componentes/styles.dart';
import 'package:provider/provider.dart';

class TelaLogin extends StatefulWidget {
  const TelaLogin({Key? key}) : super(key: key);

  @override
  State<TelaLogin> createState() => _TelaLoginState();
}

class _TelaLoginState extends State<TelaLogin> {
  final cpfController = TextEditingController();
  final senhaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final LoginProvider loginProvider = context.watch<LoginProvider>();
    loginProvider.addListener(() {
      if (loginProvider.isLogged) {
        context.read<GestorProvider>().setGestor(loginProvider.gestor);
        Navigator.of(context).pushReplacement(
          AnimatedPageTransition(
            page: PainelGestor(),
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor: corPad1,
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(
          horizontal: 40.0,
          vertical: 80.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(
              image: const AssetImage('assets/reduxLogo01.png'),
              height: MediaQuery.of(context).size.height * 0.6,
              fit: BoxFit.fitWidth,
            ),
            const SizedBox(height: 20.0),
            !loginProvider.isLoading
                ? ButtonLoginGoogle()
                : const CircularProgressIndicator(color: corPad3),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: corPad3,
        child: Container(
          height: 20,
        ),
      ),
    );
  }
}

class ButtonLoginGoogle extends StatefulWidget {
  const ButtonLoginGoogle({Key? key}) : super(key: key);

  @override
  State<ButtonLoginGoogle> createState() => _ButtonLoginGoogleState();
}

class _ButtonLoginGoogleState extends State<ButtonLoginGoogle> {
  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(corPad3),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            side: const BorderSide(
              color: Colors.white,
              width: 5,
            ),
            borderRadius: BorderRadius.circular(40),
          ),
        ),
      ),
      onPressed: () {
        context.read<LoginProvider>().setLoginMethod(GoogleLogin());
        context.read<LoginProvider>().login();
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Image(
              image: AssetImage("assets/google_icon.png"),
              height: 26.0,
            ),
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                'Entrar com Google',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
