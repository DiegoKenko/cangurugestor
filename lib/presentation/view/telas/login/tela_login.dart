import 'package:cangurugestor/const/enum/enum_auth.dart';
import 'package:cangurugestor/const/global.dart';
import 'package:cangurugestor/presentation/controller/auth_controller.dart';
import 'package:cangurugestor/presentation/state/auth_state.dart';
import 'package:cangurugestor/presentation/view/componentes/animated_page_transition.dart';
import 'package:cangurugestor/presentation/view/componentes/circular_progress.dart';
import 'package:cangurugestor/presentation/view/telas/login/widget/login_button.dart';
import 'package:cangurugestor/presentation/view/telas/login/widget/login_button_apple.dart';
import 'package:cangurugestor/presentation/view/telas/login/widget/login_button_google.dart';
import 'package:cangurugestor/presentation/view/telas/tela_initital_router.dart';
import 'package:flutter/material.dart';
import 'package:cangurugestor/presentation/view/componentes/styles.dart';

class TelaLogin extends StatefulWidget {
  const TelaLogin({Key? key}) : super(key: key);

  @override
  State<TelaLogin> createState() => _TelaLoginState();
}

class _TelaLoginState extends State<TelaLogin> {
  final AuthController authController = getIt<AuthController>();

  @override
  void initState() {
    authController.checkLogin();
    super.initState();
  }

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
                LoginButtons(authController: authController),
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
    required this.authController,
  });
  final AuthController authController;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: authController,
      builder: (context, state, _) {
        if (state is LoadingAuthState) {
          return const CircularProgressCanguru();
        } else if (state is AuthenticatedAuthState) {
          return Column(
            children: [
              Expanded(
                child: Center(
                  child: ButtonLogin(
                    image: const Icon(Icons.login),
                    text: 'Entrar',
                    onPressed: () {
                      Navigator.push(
                        context,
                        AnimatedPageTransition(
                          page: const TelaInitialRouter(),
                        ),
                      );
                    },
                    methodAuthID: EnumMethodAuthID.nenhum,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: ButtonLogin(
                  image: const Icon(Icons.logout_outlined),
                  text: 'Trocar de conta',
                  onPressed: () {
                    authController.logout();
                  },
                  methodAuthID: EnumMethodAuthID.nenhum,
                ),
              )
            ],
          );
        } else {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 20.0),
              ButtonLoginGoogle(
                onPressed: () => authController.login(EnumMethodAuthID.google),
              ),
              ButtonLoginApple(
                onPressed: () {},
              ),
            ],
          );
        }
      },
    );
  }
}
