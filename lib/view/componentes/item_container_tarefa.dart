import 'package:cangurugestor/global.dart';
import 'package:cangurugestor/model/tarefa.dart';
import 'package:cangurugestor/view/componentes/form_cadastro.dart';
import 'package:cangurugestor/view/componentes/styles.dart';
import 'package:cangurugestor/viewModel/activity_viewmodel.dart';
import 'package:cangurugestor/viewModel/provider_cuidador.dart';
import 'package:cangurugestor/viewModel/bloc_auth.dart';
import 'package:cangurugestor/viewModel/provider_paciente.dart';
import 'package:cangurugestor/viewModel/provider_tarefas.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ItemContainerTarefa extends StatefulWidget {
  final Tarefa tarefa;
  final Function()? onTap;

  const ItemContainerTarefa({
    Key? key,
    required this.tarefa,
    required this.onTap,
  }) : super(key: key);

  @override
  State<ItemContainerTarefa> createState() => _ItemContainerTarefaState();
}

class _ItemContainerTarefaState extends State<ItemContainerTarefa> {
  @override
  Widget build(BuildContext context) {
    Widget wStatus = Container();

    wStatus = StatusTarefa(
      status:
          widget.tarefa.concluida ? EnumStatus.concluido : EnumStatus.emAberto,
    );

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Card(
        shadowColor: corPad1,
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: InkWell(
          onTap: widget.onTap,
          child: Column(
            children: [
              ListTile(
                trailing: trailingTipoTarefa(widget.tarefa.tipo),
                subtitle: Text(
                  '${widget.tarefa.date} as ${widget.tarefa.time}',
                ),
                title: Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: corPad1,
                        width: 1,
                      ),
                    ),
                  ),
                  child: Text(
                    widget.tarefa.nome,
                  ),
                ),
              ),
              wStatus
            ],
          ),
        ),
      ),
    );
  }
}

class TarefaBottomSheet extends StatefulWidget {
  const TarefaBottomSheet({
    super.key,
    required this.tarefa,
  });

  final Tarefa tarefa;

  @override
  State<TarefaBottomSheet> createState() => _TarefaBottomSheetState();
}

class _TarefaBottomSheetState extends State<TarefaBottomSheet> {
  final TextEditingController _obsController = TextEditingController();

  @override
  void initState() {
    _obsController.text = widget.tarefa.observacao;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final AuthBloc authBloc = context.watch<AuthBloc>();
    return SingleChildScrollView(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              color: corPad1,
              width: double.infinity,
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.tarefa.nome,
                style: kEditTarefaTextStyle,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '${widget.tarefa.date} as ${widget.tarefa.time}',
              ),
            ),
            FormCadastro(
              enabled: true,
              multiLine: true,
              obrigatorio: true,
              onChanged: (p0) {
                widget.tarefa.observacao = p0;
              },
              controller: _obsController,
              labelText: 'Observação',
              textInputType: TextInputType.name,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  widget.tarefa.concluida
                      ? Text(
                          'realizado em ${widget.tarefa.dataConclusao} as ${widget.tarefa.horaConclusao}',
                        )
                      : const Text('em aberto'),
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Center(
                    child: FilledButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text(
                        'Voltar',
                      ),
                    ),
                  ),
                ),
                authBloc.state.login.realizaTarefa
                    ? Expanded(
                        flex: 1,
                        child: Center(
                          child: FilledButton(
                            onPressed: () {
                              Tarefa t = widget.tarefa;
                              if (!t.concluida) {
                                t.dataConclusao = DateFormat('dd/MM/yyyy')
                                    .format(DateTime.now());
                                t.horaConclusao =
                                    DateFormat('HH:mm').format(DateTime.now());
                                t.concluida = true;
                                ActivityViewModel.tarefaCuidador(
                                  t,
                                  context.read<CuidadorProvider>().cuidador,
                                  context.read<PacienteProvider>().paciente,
                                );
                              }
                              context.read<TarefasProvider>().updateTarefa(t);
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              widget.tarefa.concluida
                                  ? 'Atualizar'
                                  : 'Realizar tarefa',
                            ),
                          ),
                        ),
                      )
                    : Container(),
              ],
            )
          ],
        ),
      ),
    );
  }
}

Widget trailingTipoTarefa(EnumTarefa tipo) {
  if (tipo == EnumTarefa.atividade) {
    return kIconAtividade;
  } else if (tipo == EnumTarefa.consulta) {
    return kIconConsulta;
  } else if (tipo == EnumTarefa.medicamento) {
    return kIconMedicamento;
  } else {
    return Container();
  }
}

class StatusTarefa extends StatelessWidget {
  const StatusTarefa({super.key, required this.status});
  final EnumStatus status;

  @override
  Widget build(BuildContext context) {
    if (status == EnumStatus.nenhum) {
      return Container();
    } else {
      return Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
          color: status == EnumStatus.concluido
              ? Colors.green[300]
              : Colors.red[300],
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                status == EnumStatus.concluido ? Icons.check : Icons.cancel,
                size: 15,
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                status == EnumStatus.concluido ? 'realizado' : 'não realizado',
              ),
            ],
          ),
        ),
      );
    }
  }
}
