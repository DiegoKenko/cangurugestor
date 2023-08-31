import 'package:cangurugestor/const/global.dart';
import 'package:cangurugestor/domain/entity/cuidador_entity.dart';
import 'package:cangurugestor/presentation/controller/gestor_controller.dart';
import 'package:cangurugestor/presentation/state/gestor_state.dart';
import 'package:cangurugestor/presentation/view/componentes/adicionar_botao_rpc.dart';
import 'package:cangurugestor/presentation/view/componentes/animated_page_transition.dart';
import 'package:cangurugestor/presentation/view/componentes/item_container.dart';
import 'package:cangurugestor/presentation/view/telas/cuid/cuid_cadastro.dart';
import 'package:flutter/material.dart';

class CuidadoresGestor extends StatefulWidget {
  const CuidadoresGestor({
    Key? key,
  }) : super(key: key);

  @override
  State<CuidadoresGestor> createState() => _CuidadoresGestorState();
}

class _CuidadoresGestorState extends State<CuidadoresGestor> {
  final GestorController gestorController = getIt<GestorController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ValueListenableBuilder(
            valueListenable: gestorController,
            builder: ((context, gestorState, _) {
              if (gestorState is GestorSuccessState) {
                return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: gestorState.gestor.cuidadores.length,
                  itemBuilder: (context, index) {
                    CuidadorEntity cuidador =
                        gestorState.gestor.cuidadores[index];
                    return ItemContainer(
                      leading: const CircleAvatar(
                        backgroundImage: AssetImage('assets/avatar.png'),
                      ),
                      title: cuidador.nome,
                      subtitle: cuidador.sobrenome,
                      onTap: () {
                        Navigator.of(context).push(
                          AnimatedPageTransition(
                            page: CadastroCuidador(
                              cuidador: cuidador,
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              }
              return const Text('nenhum cuidador cadastrado');
            }),
          ),
        ),
        SizedBox(
          height: 50,
          child: Center(
            child: BotaoCadastro(
              onPressed: () {
                Navigator.of(context).push(
                  AnimatedPageTransition(
                    page: CadastroCuidador(cuidador: CuidadorEntity()),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
