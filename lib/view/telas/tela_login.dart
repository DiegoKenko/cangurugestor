import 'package:cangurugestor/autentication/auth_login.dart';
import 'package:cangurugestor/viewModel/bloc_auth.dart';
import 'package:flutter/material.dart';
import 'package:cangurugestor/view/componentes/styles.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TelaLogin extends StatefulWidget {
  const TelaLogin({Key? key}) : super(key: key);

  @override
  State<TelaLogin> createState() => _TelaLoginState();
}

class _TelaLoginState extends State<TelaLogin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: corBranco,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.1,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image(
                  image: const AssetImage('assets/reduxLogo01.png'),
                  height: MediaQuery.of(context).size.height * 0.5,
                  fit: BoxFit.fitWidth,
                ),
                const LoginButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LoginButtons extends StatelessWidget {
  const LoginButtons({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final AuthBloc auth = AuthBloc();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        const SizedBox(height: 20.0),
        auth.state.loading
            ? const CircularProgressIndicator(color: corPad1)
            : const ButtonLoginGoogle(),
        auth.state.loading ? Container() : const ButtonLoginApple(),
        auth.state.loading ? Container() : const ButtonLoginAnonymous(),
        auth.state.loading ? Container() : const ButtonLoginEmailSenha(),
      ],
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
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
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
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              controller: _emailController,
                              decoration: const InputDecoration(
                                labelText: 'E-mail',
                                labelStyle: TextStyle(color: corPreto),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: corPad1),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
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
                          BlocProvider.of<AuthBloc>(context).add(
                            LoginEvent(
                              EmailSenhaLogin(
                                _emailController.text,
                                _senhaController.text,
                              ),
                            ),
                          );
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
        image: AssetImage('assets/apple_icon.png'),
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
        image: AssetImage('assets/google_icon.png'),
        height: 26.0,
      ),
      text: 'Entrar com Google',
      methodLogin: GoogleLogin(),
    );
  }
}

class ButtonLogin extends StatefulWidget {
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
  State<ButtonLogin> createState() => _ButtonLoginState();
}

class _ButtonLoginState extends State<ButtonLogin> {
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
        onPressed: () {
          BlocProvider.of<AuthBloc>(context).add(
            LoginEvent(
              widget.methodLogin,
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              widget.image,
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  widget.text,
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
