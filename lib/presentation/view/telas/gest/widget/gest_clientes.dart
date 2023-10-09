import 'package:cangurugestor/const/global.dart';
import 'package:cangurugestor/domain/entity/responsavel_entity.dart';
import 'package:cangurugestor/presentation/controller/gestor_controller.dart';
import 'package:cangurugestor/presentation/state/gestor_state.dart';
import 'package:cangurugestor/presentation/view/componentes/adicionar_botao_rpc.dart';
import 'package:cangurugestor/presentation/view/componentes/animated_page_transition.dart';
import 'package:cangurugestor/presentation/view/componentes/item_container.dart';
import 'package:cangurugestor/presentation/view/telas/resp/resp_cadastro.dart';
import 'package:flutter/material.dart';

class ClientesGestor extends StatefulWidget {
  const ClientesGestor({
    Key? key,
  }) : super(key: key);

  @override
  State<ClientesGestor> createState() => _ClientesGestorState();
}

class _ClientesGestorState extends State<ClientesGestor> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: ValueListenableBuilder(
            valueListenable: getIt<GestorController>()..loadClientes(),
            builder: (context, gestorState, _) {
              if (gestorState is GestorSuccessState) {
                return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: gestorState.gestor.clientes.length,
                  itemBuilder: (context, index) {
                    ResponsavelEntity responsavel =
                        gestorState.gestor.clientes[index];
                    return ItemContainer(
                      leading: const CircleAvatar(
                        backgroundImage: AssetImage('assets/avatar.png'),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          AnimatedPageTransition(
                            page: CadastroResponsavel(
                              responsavel: gestorState.gestor.clientes[index],
                            ),
                          ),
                        ).then((value) {
                          getIt<GestorController>().loadClientes();
                        });
                      },
                      title: responsavel.nome,
                    );
                  },
                );
              }
              return const Text('nenhum cliente cadastrado');
            },
          ),
        ),
        SizedBox(
          height: 50,
          child: BotaoCadastro(
            onPressed: () {
              Navigator.push(
                context,
                AnimatedPageTransition(
                  page: CadastroResponsavel(
                    responsavel: ResponsavelEntity(),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
