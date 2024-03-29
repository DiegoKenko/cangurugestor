import 'package:cangurugestor/bloc/bloc_auth.dart';
import 'package:cangurugestor/bloc/bloc_auth_event.dart';
import 'package:cangurugestor/firebaseUtils/firebase_auth_constants.dart';
import 'package:cangurugestor/view/componentes/circular_progress.dart';
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
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.1,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image(
                  image: const AssetImage('assets/logo01.png'),
                  height: MediaQuery.of(context).size.height * 0.6,
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
    return Builder(
      builder: (context) {
        if (context.read<AuthBloc>().state.loading) {
          return const CircularProgressCanguru();
        } else {
          return const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 20.0),
              ButtonLoginGoogle(),
              ButtonLoginApple(),
            ],
          );
        }
      },
    );
  }
}

class ButtonLoginApple extends StatelessWidget {
  const ButtonLoginApple({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const ButtonLogin(
      image: Image(
        image: AssetImage('assets/apple_icon.png'),
        height: 26.0,
      ),
      text: 'Entrar com Apple ID',
      methodAuthID: EnumMethodAuthID.apple,
    );
  }
}

class ButtonLoginGoogle extends StatelessWidget {
  const ButtonLoginGoogle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const ButtonLogin(
      image: Image(
        image: AssetImage('assets/google_icon.png'),
        height: 26.0,
      ),
      text: 'Entrar com Google',
      methodAuthID: EnumMethodAuthID.google,
    );
  }
}

class ButtonLogin extends StatefulWidget {
  const ButtonLogin({
    Key? key,
    required this.image,
    required this.text,
    required this.methodAuthID,
  }) : super(key: key);
  final EnumMethodAuthID methodAuthID;
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
          backgroundColor: MaterialStateProperty.all(corPad1.withOpacity(0.1)),
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
          context.read<AuthBloc>().add(
                LoginEvent(
                  widget.methodAuthID,
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
