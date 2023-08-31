import 'package:cangurugestor/const/enum/enum_auth.dart';
import 'package:cangurugestor/presentation/view/telas/login/widget/login_button.dart';
import 'package:flutter/material.dart';

class ButtonLoginApple extends StatelessWidget {
  const ButtonLoginApple({Key? key, required this.onPressed}) : super(key: key);
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return ButtonLogin(
      image: const Image(
        image: AssetImage('assets/apple_icon.png'),
        height: 26.0,
      ),
      text: 'Entrar com Apple ID',
      methodAuthID: EnumMethodAuthID.apple,
      onPressed: onPressed,
    );
  }
}
