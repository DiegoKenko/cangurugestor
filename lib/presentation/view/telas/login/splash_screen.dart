import 'package:cangurugestor/const/global.dart';
import 'package:cangurugestor/presentation/controller/auth_controller.dart';
import 'package:cangurugestor/presentation/state/auth_state.dart';
import 'package:cangurugestor/presentation/view/componentes/animated_page_transition.dart';
import 'package:cangurugestor/presentation/view/telas/login/tela_login.dart';
import 'package:cangurugestor/presentation/view/telas/tela_initital_router.dart';
import 'package:flutter/material.dart';
import 'package:cangurugestor/presentation/view/componentes/styles.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  AuthController authController = getIt<AuthController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: corBranco,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.1,
          ),
          child: FutureBuilder(
            future: Future.delayed(const Duration(seconds: 2)),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                Future.microtask(() {
                  authController.checkLogin().then((pessoa) {
                    if (pessoa != null &&
                        authController.value is AuthenticatedAuthState) {
                      Navigator.pushReplacement(
                        context,
                        AnimatedPageTransition(
                          page: TelaInitialRouter(pessoa: pessoa),
                        ),
                      );
                    } else if (authController.value
                            is UnauthenticatedAuthState ||
                        authController.value is ErrorAuthState) {
                      Navigator.pushReplacement(
                        context,
                        AnimatedPageTransition(
                          page: const TelaLogin(),
                        ),
                      );
                    }
                  });
                });
              }
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(
                    image: const AssetImage('assets/logo01.png'),
                    height: MediaQuery.of(context).size.height * 0.6,
                    fit: BoxFit.fitWidth,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
