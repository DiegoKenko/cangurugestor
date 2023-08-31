import 'package:cangurugestor/const/global.dart';
import 'package:cangurugestor/domain/entity/paciente_entity.dart';
import 'package:cangurugestor/domain/entity/responsavel_entity.dart';
import 'package:cangurugestor/presentation/controller/responsavel_controller.dart';
import 'package:cangurugestor/presentation/state/responsavel_state.dart';
import 'package:cangurugestor/presentation/view/componentes/adicionar_botao_rpc.dart';
import 'package:cangurugestor/presentation/view/componentes/animated_page_transition.dart';
import 'package:cangurugestor/presentation/view/componentes/item_container.dart';
import 'package:cangurugestor/presentation/view/telas/paci/paci_cadastro.dart';
import 'package:flutter/material.dart';

class PacientesResponsavel extends StatelessWidget {
  const PacientesResponsavel({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: getIt<ResponsavelController>(),
      builder: (context, state, _) {
        ResponsavelEntity responsavel = ResponsavelEntity();
        if (state is ResponsavelSuccessState) {
          responsavel = state.responsavel;
        }
        return Column(
          children: [
            responsavel.pacientes.isEmpty
                ? const Expanded(
                    child: Center(
                      child: Text('nenhum paciente cadastrado'),
                    ),
                  )
                : Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: responsavel.pacientes.length,
                      itemBuilder: (context, index) {
                        PacienteEntity paciente = responsavel.pacientes[index];
                        return ItemContainer(
                          leading: const CircleAvatar(
                            backgroundImage: AssetImage('assets/avatar.png'),
                          ),
                          onTap: () {
                            Navigator.of(context).push(
                              AnimatedPageTransition(
                                page: const CadastroPaciente(),
                              ),
                            );
                          },
                          title: paciente.nome,
                        );
                      },
                    ),
                  ),
            SizedBox(
              height: 50,
              child: Center(
                child: BotaoCadastro(
                  onPressed: () {
                    Navigator.of(context).push(
                      AnimatedPageTransition(
                        page: const CadastroPaciente(),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
