import 'package:cangurugestor/firebaseUtils/fire_login.dart';
import 'package:cangurugestor/firebaseUtils/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:cangurugestor/ui/componentes/styles.dart';

class TelaLogin extends StatefulWidget {
  const TelaLogin({Key? key}) : super(key: key);

  @override
  State<TelaLogin> createState() => _TelaLoginState();
}

class _TelaLoginState extends State<TelaLogin> {
  final cpfController = TextEditingController();
  final senhaController = TextEditingController();
  final FirestoreLogin firestoreLogin = FirestoreLogin();
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
            !isLoading
                ? OutlinedButton(
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
                      setState(() {
                        isLoading = true;
                        SignIn().signInWithGoogle().then((result) {
                          firestoreLogin.autenticarUsuarioGoogle(
                              context, result.user!);
                        });
                      });
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
                          )
                        ],
                      ),
                    ),
                  )
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
