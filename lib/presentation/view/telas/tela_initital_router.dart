import 'package:cangurugestor/const/enum/enum_classe.dart';
import 'package:cangurugestor/const/global.dart';
import 'package:cangurugestor/domain/entity/gestor_entity.dart';
import 'package:cangurugestor/presentation/controller/auth_controller.dart';
import 'package:cangurugestor/presentation/view/telas/cuid/cuid_painel.dart';
import 'package:cangurugestor/presentation/view/telas/gest/gest_painel.dart';
import 'package:cangurugestor/presentation/view/telas/login/tela_login.dart';
import 'package:cangurugestor/presentation/view/telas/resp/resp_painel.dart';
import 'package:flutter/material.dart';

class TelaInitialRouter extends StatefulWidget {
  const TelaInitialRouter({super.key});

  @override
  State<TelaInitialRouter> createState() => _TelaInitialRouterState();
}

class _TelaInitialRouterState extends State<TelaInitialRouter> {
  final AuthController authController = getIt<AuthController>();
  @override
  Widget build(BuildContext context) {
    if (authController.current != null) {
      if (authController.role == EnumClasse.cuidador) {
        return const PainelCuidador();
      }
      if (authController.role == EnumClasse.gestor) {
        return PainelGestor(
          gestor: GestorEntity.fromPessoa(authController.current!),
        );
      }
      if (authController.role == EnumClasse.responsavel) {
        return const PainelResponsavel();
      }
    }

    return const TelaLogin();
  }
}
