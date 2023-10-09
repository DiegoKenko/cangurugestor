import 'package:cangurugestor/const/enum/enum_intervalo.dart';
import 'package:cangurugestor/domain/entity/atividade_entity.dart';
import 'package:cangurugestor/domain/entity/tarefa_entity.dart';
import 'package:cangurugestor/presentation/state/atividade_state.dart';
import 'package:cangurugestor/presentation/state/paciente_tarefas_state.dart';
import 'package:cangurugestor/presentation/view/componentes/adicionar_botao_rpc.dart';
import 'package:cangurugestor/presentation/view/componentes/dialog_confirmacao_exclusao.dart';
import 'package:cangurugestor/presentation/view/componentes/form_cadastro.dart';
import 'package:cangurugestor/presentation/view/componentes/form_dropdown.dart';
import 'package:cangurugestor/presentation/view/componentes/item_container_tarefa.dart';
import 'package:cangurugestor/presentation/view/componentes/popup_tarefa.dart';
import 'package:cangurugestor/presentation/view/componentes/styles.dart';
import 'package:cangurugestor/presentation/view/componentes/tab.dart';
import 'package:cangurugestor/presentation/controller/atividade_controller.dart';
import 'package:cangurugestor/presentation/controller/paciente_tarefas_controller.dart';
import 'package:flutter/material.dart';

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
    _tabController.addListener(() {});
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
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
                    onConfirm: () {},
                  );
                },
              );

              Navigator.of(context).pop();
            },
          ),
        ],
        centerTitle: true,
        title: ValueListenableBuilder(
          valueListenable: AtividadeController(),
          builder: (context, state, _) {
            if (state is AtividadeSuccessState) {
              return Column(
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
              );
            }
            return Container();
          },
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
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
        child: ValueListenableBuilder(
          valueListenable: PacienteTarefasController(),
          builder: (context, tarefasState, _) {
            var widgetTarefaSalvas = [];
            if (tarefasState is ListaTarefasSuccessState) {
              widgetTarefaSalvas = tarefasState.tarefas
                  .map(
                    (TarefaEntity tarefa) => ItemContainerTarefa(
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
            }

            return Column(
              children: [
                ...widgetTarefaSalvas,
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: BotaoCadastro(
                    onPressed: () {},
                  ),
                ),
              ],
            );
            /* 
              return Column(
                children: [
                  ...widgetTarefaSalvas,
                ],
              ); */
          },
        ),
      ),
    );
  }
}

class DadosAtividade extends StatefulWidget {
  const DadosAtividade({
    Key? key,
    this.atividade,
  }) : super(key: key);
  final AtividadeEntity atividade;

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
    _descricaoController.addListener(() {});
    _localController.addListener(() {});
    _observacaoController.addListener(() {});
    _duracaoController.addListener(() {});
    _duracaoUMController.addListener(() {});
    _frequenciaQtdeController.addListener(() {});
    _frequenciaUMController.addListener(() {});

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
      child: ValueListenableBuilder(
        valueListenable: AtividadeController(),
        builder: (context, state, _) {
          if (state is AtividadeSuccessState) {
            atividade = state.atividade;
            _descricaoController.text = state.atividade.descricao;
            _localController.text = state.atividade.local;
            _observacaoController.text = state.atividade.observacao;
            _duracaoController.text =
                state.atividade.duracaoQuantidade.toString();
            _duracaoUMController.text = state.atividade.duracaoMedida.name;
            _frequenciaQtdeController.text =
                state.atividade.frequenciaQuantidade.toString();
            _frequenciaUMController.text =
                state.atividade.frequenciaMedida.name;
          }
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
                      value: atividade.duracaoMedida.name,
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
                      value: atividade.frequenciaMedida.name,
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
