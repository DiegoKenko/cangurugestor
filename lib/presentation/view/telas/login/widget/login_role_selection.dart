import 'package:cangurugestor/const/enum/enum_classe.dart';
import 'package:flutter/material.dart';

class LoginRoleSelection extends StatefulWidget {
  const LoginRoleSelection({super.key, required this.callback});
  final Function(EnumClasse) callback;

  @override
  State<LoginRoleSelection> createState() => _LoginRoleSelectionState();
}

class _LoginRoleSelectionState extends State<LoginRoleSelection> {
  final ValueNotifier<EnumClasse> role =
      ValueNotifier<EnumClasse>(EnumClasse.naoDefinido);
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: role,
      builder: (context, state, _) {
        return Column(
          children: [
            CheckboxListTile(
              title: const Text('Sou um cuidador'),
              value: state == EnumClasse.cuidador,
              onChanged: (value) {
                if (value == true) {
                  role.value = EnumClasse.cuidador;
                } else {
                  role.value = EnumClasse.naoDefinido;
                }
              },
            ),
            CheckboxListTile(
              title: const Text('Sou um responsável'),
              value: state == EnumClasse.responsavel,
              onChanged: (value) {
                if (value == true) {
                  role.value = EnumClasse.responsavel;
                } else {
                  role.value = EnumClasse.naoDefinido;
                }
              },
            ),
            CheckboxListTile(
              title: const Text('Sou um gestor'),
              value: state == EnumClasse.gestor,
              onChanged: (value) {
                if (value == true) {
                  role.value = EnumClasse.gestor;
                } else {
                  role.value = EnumClasse.naoDefinido;
                }
              },
            ),
            ElevatedButton(
              onPressed: state == EnumClasse.naoDefinido
                  ? null
                  : () {
                      widget.callback(state);
                    },
              child: const Text('Entrar'),
            ),
          ],
        );
      },
    );
  }
}
