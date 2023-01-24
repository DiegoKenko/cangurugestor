import 'package:cangurugestor/autentication/auth_login.dart';
import 'package:cangurugestor/global.dart';
import 'package:cangurugestor/model/cuidador.dart';
import 'package:cangurugestor/model/gestor.dart';
import 'package:cangurugestor/model/responsavel.dart';
import 'package:cangurugestor/view/componentes/animated_page_transition.dart';
import 'package:cangurugestor/viewModel/provider_cuidador.dart';
import 'package:cangurugestor/viewModel/provider_gestor.dart';
import 'package:cangurugestor/viewModel/provider_login.dart';
import 'package:cangurugestor/viewModel/provider_responsavel.dart';
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
        if (loginProvider.classe == EnumClasse.gestor) {
          context.read<GestorProvider>().gestor = loginProvider.user as Gestor;
        }
        if (loginProvider.classe == EnumClasse.cuidador) {
          context.read<CuidadorProvider>().cuidador =
              loginProvider.user as Cuidador;
        }
        if (loginProvider.classe == EnumClasse.responsavel) {
          context.read<ResponsavelProvider>().responsavel =
              loginProvider.user as Responsavel;
        }
        Navigator.of(context).pushReplacement(
          AnimatedPageTransition(
            page: loginProvider.route!,
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor: corPad1.withOpacity(0.8),
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
              height: MediaQuery.of(context).size.height * 0.5,
              fit: BoxFit.fitWidth,
            ),
            const SizedBox(height: 20.0),
            !loginProvider.isLoading
                ? const ButtonLoginGoogle()
                : const CircularProgressIndicator(color: corPad1),
            !loginProvider.isLoading ? const ButtonLoginApple() : Container(),
            !loginProvider.isLoading
                ? const ButtonLoginAnonymous()
                : Container(),
            !loginProvider.isLoading
                ? const ButtonLoginEmailSenha()
                : Container(),
          ],
        ),
      ),
    );
  }
}

class ButtonLoginEmailSenha extends StatelessWidget {
  const ButtonLoginEmailSenha({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ButtonLogin(
      image: const Icon(Icons.mail, color: corPreto, size: 26.0),
      text: 'E-mail e senha',
      onPressed: () {
        //context.read<LoginProvider>().setLoginMethod(());
        context.read<LoginProvider>().login();
      },
    );
  }
}

class ButtonLoginAnonymous extends StatelessWidget {
  const ButtonLoginAnonymous({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ButtonLogin(
      image: const Icon(Icons.person, color: corPreto, size: 26.0),
      text: 'Anônimo',
      onPressed: () {
        //context.read<LoginProvider>().setLoginMethod(());
        context.read<LoginProvider>().login();
      },
    );
  }
}

class ButtonLoginApple extends StatelessWidget {
  const ButtonLoginApple({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ButtonLogin(
      image: const Image(
        image: AssetImage("assets/apple_icon.png"),
        height: 26.0,
      ),
      text: 'Entrar com Apple ID',
      onPressed: () {
        //context.read<LoginProvider>().setLoginMethod(());
        context.read<LoginProvider>().login();
      },
    );
  }
}

class ButtonLoginGoogle extends StatelessWidget {
  const ButtonLoginGoogle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ButtonLogin(
      image: const Image(
        image: AssetImage("assets/google_icon.png"),
        height: 26.0,
      ),
      text: 'Entrar com Google',
      onPressed: () {
        context.read<LoginProvider>().setLoginMethod(GoogleLogin());
        context.read<LoginProvider>().login();
      },
    );
  }
}

class ButtonLogin extends StatelessWidget {
  const ButtonLogin({
    Key? key,
    required this.onPressed,
    required this.image,
    required this.text,
  }) : super(key: key);
  final Function()? onPressed;
  final Widget image;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: OutlinedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(corBranco),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              side: const BorderSide(
                color: corPad1,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
        onPressed: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              image,
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  text,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
