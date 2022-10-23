import 'package:cangurugestor/firebaseUtils/firestore_funcoes.dart';
import 'package:cangurugestor/firebaseUtils/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:cangurugestor/ui/componentes/styles.dart';
import 'package:flutter/services.dart';

class TelaLogin extends StatefulWidget {
  const TelaLogin({Key? key}) : super(key: key);

  @override
  State<TelaLogin> createState() => _TelaLoginState();
}

class _TelaLoginState extends State<TelaLogin> {
  final cpfController = TextEditingController();
  final senhaController = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: corPad1,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Center(
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(
                horizontal: 40.0,
                vertical: 80.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Image(
                    image: AssetImage('assets/reduxLogo01.png'),
                    fit: BoxFit.fill,
                  ),
                  const SizedBox(height: 20.0),
                  OutlinedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(corPad1),
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
                      _loading();
                      setState(() {
                        SignIn().signInWithGoogle().then((result) {
                          MeuFirestore()
                              .autenticarUsuarioGoogle(context, result.user!);
                        });
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const <Widget>[
                          Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Text(
                              'Entrar com Google',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
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

  Future<void> _loading() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Colors.transparent,
            child: const Center(child: CircularProgressIndicator()),
          ),
        );
      },
    );
  }
}
