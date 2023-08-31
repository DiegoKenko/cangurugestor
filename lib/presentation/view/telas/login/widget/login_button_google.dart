import 'package:cangurugestor/const/enum/enum_auth.dart';
import 'package:cangurugestor/presentation/view/telas/login/widget/login_button.dart';
import 'package:flutter/material.dart';

class ButtonLoginGoogle extends StatelessWidget {
  const ButtonLoginGoogle({Key? key, required this.onPressed})
      : super(key: key);
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return ButtonLogin(
      image: const Image(
        image: AssetImage('assets/google_icon.png'),
        height: 26.0,
      ),
      text: 'Entrar com Google',
      methodAuthID: EnumMethodAuthID.google,
      onPressed: onPressed,
    );
  }
}
