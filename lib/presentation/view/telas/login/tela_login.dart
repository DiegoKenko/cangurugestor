import 'package:cangurugestor/const/enum/enum_auth.dart';
import 'package:cangurugestor/const/global.dart';
import 'package:cangurugestor/presentation/controller/auth_controller.dart';
import 'package:cangurugestor/presentation/state/auth_state.dart';
import 'package:cangurugestor/presentation/view/componentes/animated_page_transition.dart';
import 'package:cangurugestor/presentation/view/componentes/circular_progress.dart';
import 'package:cangurugestor/presentation/view/telas/login/splash_screen.dart';
import 'package:cangurugestor/presentation/view/telas/login/widget/login_button.dart';
import 'package:cangurugestor/presentation/view/telas/login/widget/login_button_apple.dart';
import 'package:cangurugestor/presentation/view/telas/login/widget/login_button_google.dart';
import 'package:cangurugestor/presentation/view/telas/login/widget/login_role_selection.dart';
import 'package:cangurugestor/presentation/view/telas/tela_initital_router.dart';
import 'package:flutter/material.dart';
import 'package:cangurugestor/presentation/view/componentes/styles.dart';

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

class LoginButtons extends StatefulWidget {
  const LoginButtons({
    super.key,
  });

  @override
  State<LoginButtons> createState() => _LoginButtonsState();
}

class _LoginButtonsState extends State<LoginButtons> {
  final AuthController authController = getIt<AuthController>();

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
              ButtonLogin(
                image: const Icon(Icons.login),
                text: 'Entrar',
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    AnimatedPageTransition(
                      page: TelaInitialRouter(pessoa: authController.current!),
                    ),
                  );
                },
                methodAuthID: EnumMethodAuthID.nenhum,
              ),
              Container(
                alignment: Alignment.center,
                height: 30,
                child: const Text('ou'),
              ),
              ButtonLogin(
                image: const Icon(Icons.switch_right),
                text: 'Alterar conta',
                onPressed: () async {
                  authController.logout();
                  Navigator.pushReplacement(
                    context,
                    AnimatedPageTransition(
                      page: const SplashScreen(),
                    ),
                  );
                },
                methodAuthID: EnumMethodAuthID.nenhum,
              ),
            ],
          );
        } else if (state is UnauthenticatedAuthState) {
          if (state.user == null) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 20.0),
                ButtonLoginGoogle(
                  onPressed: () async =>
                      await authController.login(EnumMethodAuthID.google),
                ),
                Container(
                  alignment: Alignment.center,
                  height: 30,
                  child: const Text('ou'),
                ),
                ButtonLoginApple(
                  onPressed: () {},
                ),
              ],
            );
          } else {
            return Center(
              child: LoginRoleSelection(
                callback: (p0) async {
                  authController.createLogin(state.user!, p0).then(
                        (pessoa) => pessoa != null
                            ? Navigator.pushReplacement(
                                context,
                                AnimatedPageTransition(
                                  page: TelaInitialRouter(pessoa: pessoa),
                                ),
                              )
                            : null,
                      );
                },
              ),
            );
          }
        } else {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 20.0),
              ButtonLoginGoogle(
                onPressed: () async =>
                    await authController.login(EnumMethodAuthID.google),
              ),
              Container(
                alignment: Alignment.center,
                height: 30,
                child: const Text('ou'),
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
