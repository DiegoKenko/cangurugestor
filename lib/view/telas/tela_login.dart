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
  @override
  Widget build(BuildContext context) {
    final LoginProvider loginProvider = context.watch<LoginProvider>();

    loginProvider.addListener(() {
      if (loginProvider.isLogged) {
        if (loginProvider.classe == EnumClasse.gestor) {
          context.read<GestorProvider>().gestor = loginProvider.user as Gestor;
        } else if (loginProvider.classe == EnumClasse.responsavel) {
          context.read<ResponsavelProvider>().responsavel =
              loginProvider.user as Responsavel;
        } else if (loginProvider.classe == EnumClasse.cuidador) {
          context.read<CuidadorProvider>().cuidador =
              loginProvider.user as Cuidador;
        }
        Navigator.of(context).push(
          AnimatedPageTransition(
            page: loginProvider.route,
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor: corBranco,
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 40.0,
        ),
        child: Column(
          children: [
            Image(
              image: const AssetImage('assets/reduxLogo01.png'),
              height: MediaQuery.of(context).size.height * 0.5,
              fit: BoxFit.fitWidth,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(height: 20.0),
                  !loginProvider.isLoading
                      ? const ButtonLoginGoogle()
                      : const CircularProgressIndicator(color: corPad1),
                  !loginProvider.isLoading
                      ? const ButtonLoginApple()
                      : Container(),
                  !loginProvider.isLoading
                      ? const ButtonLoginAnonymous()
                      : Container(),
                  !loginProvider.isLoading
                      ? const ButtonLoginEmailSenha()
                      : Container(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ButtonLoginEmailSenha extends StatefulWidget {
  const ButtonLoginEmailSenha({Key? key}) : super(key: key);

  @override
  State<ButtonLoginEmailSenha> createState() => _ButtonLoginEmailSenhaState();
}

class _ButtonLoginEmailSenhaState extends State<ButtonLoginEmailSenha> {
  bool _showPassword = false;
  bool _tapped = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: OutlinedButton(
            onPressed: () {
              setState(() {
                _tapped = !_tapped;
              });
            },
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
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: const <Widget>[
                  Icon(Icons.mail, color: corPreto, size: 26.0),
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text(
                      'E-mail e senha',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        _tapped
            ? Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        children: [
                          TextField(
                            controller: _emailController,
                            decoration: const InputDecoration(
                              labelText: 'E-mail',
                              labelStyle: TextStyle(color: corPreto),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: corPad1),
                              ),
                            ),
                          ),
                          TextField(
                            controller: _senhaController,
                            obscureText: !_showPassword,
                            decoration: InputDecoration(
                              labelText: 'Senha',
                              labelStyle: const TextStyle(color: corPreto),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: corPad1),
                              ),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _showPassword = !_showPassword;
                                  });
                                },
                                icon: Icon(
                                  _showPassword
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: corPreto,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 30,
                    child: Center(
                      child: IconButton(
                        onPressed: () {
                          context.read<LoginProvider>().method =
                              EmailSenhaLogin(
                            _emailController.text,
                            _senhaController.text,
                          );
                          context.read<LoginProvider>().login();
                        },
                        icon: const Icon(
                          Icons.chevron_right,
                          size: 50,
                          color: corPad1,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : Container(),
      ],
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
      methodLogin: AnonymousLogin(),
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
      methodLogin: AppleIDLogin(),
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
      methodLogin: GoogleLogin(),
    );
  }
}

class ButtonLogin extends StatelessWidget {
  const ButtonLogin({
    Key? key,
    required this.image,
    required this.text,
    required this.methodLogin,
  }) : super(key: key);
  final MethodLogin methodLogin;
  final Widget image;
  final String text;

  @override
  Widget build(BuildContext context) {
    void onPressed() {
      context.read<LoginProvider>().method = methodLogin;
      context.read<LoginProvider>().login();
    }

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
