import 'package:cangurugestor/domain/entity/cuidador_entity.dart';
import 'package:cangurugestor/domain/entity/gestor_entity.dart';
import 'package:cangurugestor/domain/entity/pessoa_entity.dart';
import 'package:cangurugestor/domain/entity/responsavel_entity.dart';
import 'package:cangurugestor/presentation/view/telas/cuid/cuid_painel.dart';
import 'package:cangurugestor/presentation/view/telas/gest/gest_painel.dart';
import 'package:cangurugestor/presentation/view/telas/login/tela_login.dart';
import 'package:cangurugestor/presentation/view/telas/resp/resp_painel.dart';
import 'package:flutter/material.dart';

class TelaInitialRouter extends StatefulWidget {
  const TelaInitialRouter({super.key, required this.pessoa});
  final PessoaEntity pessoa;

  @override
  State<TelaInitialRouter> createState() => _TelaInitialRouterState();
}

class _TelaInitialRouterState extends State<TelaInitialRouter> {
  @override
  Widget build(BuildContext context) {
    if (widget.pessoa is CuidadorEntity) {
      return PainelCuidador(cuidador: widget.pessoa as CuidadorEntity);
    }
    if (widget.pessoa is GestorEntity) {
      return PainelGestor(gestor: widget.pessoa as GestorEntity);
    }
    if (widget.pessoa is ResponsavelEntity) {
      return PainelResponsavel(responsavel: widget.pessoa as ResponsavelEntity);
    } else {
      return const TelaLogin();
    }
  }
}
