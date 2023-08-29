import 'package:cangurugestor/enum/enum_intervalo.dart';
import 'package:cangurugestor/enum/enum_tarefa.dart';
import 'package:cangurugestor/model/tarefa.dart';
import 'package:cangurugestor/view/componentes/adicionar_botao_rpc.dart';
import 'package:cangurugestor/view/componentes/dialog_confirmacao_exclusao.dart';
import 'package:cangurugestor/view/componentes/form_cadastro.dart';
import 'package:cangurugestor/view/componentes/form_dropdown.dart';
import 'package:cangurugestor/view/componentes/item_container_tarefa.dart';
import 'package:cangurugestor/view/componentes/popup_tarefa.dart';
import 'package:cangurugestor/view/componentes/styles.dart';
import 'package:cangurugestor/view/componentes/tab.dart';
import 'package:cangurugestor/viewModel/bloc_atividade.dart';
import 'package:cangurugestor/bloc/bloc_auth.dart';
import 'package:cangurugestor/viewModel/bloc_lista_tarefas_paciente.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CadastroAtividade extends StatefulWidget {
  const CadastroAtividade({
    Key? key,
  }) : super(key: key);

  @override
  State<CadastroAtividade> createState() => _CadastroAtividadeState();
}

class _CadastroAtividadeState extends State<CadastroAtividade>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (context.read<AuthBloc>().state.login.editaAtividade) {
        context.read<AtividadeBloc>().add(AtividadeUpdateEvent());
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AtividadeBloc, AtividadeState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                if (context.read<AuthBloc>().state.login.editaAtividade) {
                  context.read<AtividadeBloc>().add(AtividadeUpdateEvent());
                }
                Navigator.of(context).pop();
              },
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return DialogConfirmacaoExclusao(
                        onConfirm: () {
                          context
                              .read<AtividadeBloc>()
                              .add(AtividadeDeleteEvent());
                        },
                      );
                    },
                  );

                  Navigator.of(context).pop();
                },
              ),
            ],
            centerTitle: true,
            title: Column(
              children: [
                Text(
                  state.atividade.descricao.toUpperCase(),
                  style: kTitleAppBarStyle,
                ),
                Text(
                  'atividade',
                  style: kSubtitleAppBarStyle,
                ),
              ],
            ),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 30, bottom: 30),
              child: TabCanguru(
                controller: _tabController,
                tabs: const [
                  Tab(
                    text: 'Dados',
                  ),
                  Tab(
                    text: 'Tarefas',
                  ),
                ],
                views: const [
                  Tab(
                    child: DadosAtividade(),
                  ),
                  Tab(
                    child: TarefasAtividade(),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class TarefasAtividade extends StatefulWidget {
  const TarefasAtividade({
    Key? key,
  }) : super(key: key);

  @override
  State<TarefasAtividade> createState() => _TarefasAtividadeState();
}

class _TarefasAtividadeState extends State<TarefasAtividade> {
  final ListaTarefasPacienteBloc tarefasBloc = ListaTarefasPacienteBloc();
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
        child: BlocBuilder<ListaTarefasPacienteBloc, ListaTarefaPacienteState>(
          bloc: tarefasBloc
            ..add(
              ListaTarefasLoadEvent(
                paciente:
                    context.read<AtividadeBloc>().state.atividade.paciente,
                tipo: EnumTarefa.atividade,
                idTipo: context.read<AtividadeBloc>().state.atividade.id,
              ),
            ),
          builder: (context, tarefasState) {
            var widgetTarefaSalvas = tarefasState.tarefas
                .map(
                  (Tarefa tarefa) => ItemContainerTarefa(
                    tarefa: tarefa,
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => PopUpTarefa(
                          tarefa: tarefa,
                        ),
                      ).then((value) {
                        setState(() {});
                      });
                    },
                  ),
                )
                .toList();
            if (context.read<AuthBloc>().state.login.editaAtividade) {
              return Column(
                children: [
                  ...widgetTarefaSalvas,
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: BotaoCadastro(
                      onPressed: () {
                        tarefasBloc.add(
                          ListaTarefasAddEvent(
                            EnumTarefa.atividade,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            } else {
              return Column(
                children: [
                  ...widgetTarefaSalvas,
                ],
              );
            }
          },
        ),
      ),
    );
  }
}

class DadosAtividade extends StatefulWidget {
  const DadosAtividade({
    Key? key,
  }) : super(key: key);

  @override
  State<DadosAtividade> createState() => _DadosAtividadeState();
}

class _DadosAtividadeState extends State<DadosAtividade> {
  final TextEditingController _descricaoController = TextEditingController();
  final TextEditingController _localController = TextEditingController();
  final TextEditingController _observacaoController = TextEditingController();
  final TextEditingController _duracaoController = TextEditingController();
  final TextEditingController _duracaoUMController = TextEditingController();
  final TextEditingController _frequenciaQtdeController =
      TextEditingController();
  final TextEditingController _frequenciaUMController = TextEditingController();

  @override
  void initState() {
    _descricaoController.addListener(() {
      // Listener para atualizar a descrição da atividade
      context.read<AtividadeBloc>().state.atividade.descricao =
          _descricaoController.text;
    });
    _localController.addListener(() {
      // Listener para atualizar a descrição da atividade
      context.read<AtividadeBloc>().state.atividade.local =
          _localController.text;
    });
    _observacaoController.addListener(() {
      // Listener para atualizar a descrição da atividade
      context.read<AtividadeBloc>().state.atividade.observacao =
          _observacaoController.text;
    });
    _duracaoController.addListener(() {
      // Listener para atualizar a descrição da atividade
      context.read<AtividadeBloc>().state.atividade.duracaoQuantidade =
          double.parse(_duracaoController.text);
    });
    _duracaoUMController.addListener(() {
      // Listener para atualizar a descrição da atividade
      context.read<AtividadeBloc>().state.atividade.duracaoMedida =
          EnumIntervalo.values.firstWhere(
        (EnumIntervalo element) => element.name == _duracaoUMController.text,
        orElse: () => EnumIntervalo.minutos,
      );
    });
    _frequenciaQtdeController.addListener(() {
      // Listener para atualizar a descrição da atividade
      context.read<AtividadeBloc>().state.atividade.frequenciaQuantidade =
          double.parse(
        _frequenciaQtdeController.text.isEmpty
            ? '0'
            : _frequenciaQtdeController.text,
      );
    });
    _frequenciaUMController.addListener(() {
      // Listener para atualizar a descrição da atividade
      context.read<AtividadeBloc>().state.atividade.frequenciaMedida =
          EnumIntervalo.values.firstWhere(
        (EnumIntervalo element) => element.name == _frequenciaUMController.text,
        orElse: () => EnumIntervalo.minutos,
      );
    });

    super.initState();
  }

  @override
  void dispose() {
    _descricaoController.dispose();
    _localController.dispose();
    _observacaoController.dispose();
    _duracaoController.dispose();
    _duracaoUMController.dispose();
    _frequenciaQtdeController.dispose();
    _frequenciaUMController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: BlocBuilder<AtividadeBloc, AtividadeState>(
        builder: (context, state) {
          _descricaoController.text = state.atividade.descricao;
          _localController.text = state.atividade.local;
          _observacaoController.text = state.atividade.observacao;
          _duracaoController.text =
              state.atividade.duracaoQuantidade.toString();
          _duracaoUMController.text = state.atividade.duracaoMedida.name;
          _frequenciaQtdeController.text =
              state.atividade.frequenciaQuantidade.toString();
          _frequenciaUMController.text = state.atividade.frequenciaMedida.name;
          return Column(
            children: [
              FormCadastro(
                obrigatorio: true,
                textInputType: TextInputType.name,
                enabled: true,
                controller: _descricaoController,
                labelText: 'Nome',
              ),
              FormCadastro(
                obrigatorio: true,
                textInputType: TextInputType.name,
                enabled: true,
                controller: _localController,
                labelText: 'Local',
              ),
              FormCadastro(
                obrigatorio: true,
                textInputType: TextInputType.name,
                enabled: true,
                controller: _observacaoController,
                labelText: 'Observação',
              ),
              Row(
                children: [
                  Expanded(
                    child: FormCadastro(
                      obrigatorio: true,
                      textInputType: TextInputType.number,
                      enabled: true,
                      controller: _duracaoController,
                      labelText: 'Duracao:',
                    ),
                  ),
                  Expanded(
                    child: FormDropDown(
                      lista: EnumIntervalo.values
                          .map((e) => e.name)
                          .toList(growable: false),
                      controller: _duracaoUMController,
                      value: state.atividade.duracaoMedida.name,
                      hintText: 'Intervalo',
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: FormCadastro(
                      obrigatorio: true,
                      textInputType: TextInputType.number,
                      enabled: true,
                      controller: _frequenciaQtdeController,
                      labelText: 'a cada:',
                    ),
                  ),
                  Expanded(
                    child: FormDropDown(
                      lista: EnumIntervalo.values
                          .map((e) => e.name)
                          .toList(growable: false),
                      controller: _frequenciaUMController,
                      value: state.atividade.frequenciaMedida.name,
                      hintText: 'Intervalo',
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
