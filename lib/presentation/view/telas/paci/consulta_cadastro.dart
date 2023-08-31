import 'package:cangurugestor/domain/entity/tarefa_entity.dart';
import 'package:cangurugestor/presentation/state/consulta_state.dart';
import 'package:cangurugestor/presentation/state/paciente_tarefas_state.dart';
import 'package:cangurugestor/presentation/view/componentes/adicionar_botao_rpc.dart';
import 'package:cangurugestor/presentation/view/componentes/dialog_confirmacao_exclusao.dart';
import 'package:cangurugestor/presentation/view/componentes/form_cadastro.dart';
import 'package:cangurugestor/presentation/view/componentes/item_container_tarefa.dart';
import 'package:cangurugestor/presentation/view/componentes/popup_tarefa.dart';
import 'package:cangurugestor/presentation/view/componentes/styles.dart';
import 'package:cangurugestor/presentation/view/componentes/tab.dart';
import 'package:cangurugestor/presentation/controller/consulta_controller.dart';
import 'package:cangurugestor/presentation/controller/paciente_tarefas_controller.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class CadastroConsulta extends StatefulWidget {
  const CadastroConsulta({
    Key? key,
  }) : super(key: key);

  @override
  State<CadastroConsulta> createState() => _CadastroConsultaState();
}

class _CadastroConsultaState extends State<CadastroConsulta>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ConsultaController consultaController = ConsultaController();

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
            },
          ),
        ],
        centerTitle: true,
        title: Column(
          children: [
            ValueListenableBuilder(
              valueListenable: consultaController,
              builder: (context, state, _) {
                if (state is ConsultaSuccessState) {
                  return Text(
                    state.consulta.descricao.toUpperCase(),
                    style: kTitleAppBarStyle,
                  );
                }
                return Container();
              },
            ),
            Text(
              'consulta',
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
                child: DadosConsulta(),
              ),
              Tab(
                child: TarefasConsulta(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TarefasConsulta extends StatefulWidget {
  const TarefasConsulta({
    Key? key,
  }) : super(key: key);

  @override
  State<TarefasConsulta> createState() => _TarefasConsultaState();
}

class _TarefasConsultaState extends State<TarefasConsulta> {
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
              tarefasState.tarefas
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
          },
        ),
      ),
    );
  }
}

class DadosConsulta extends StatefulWidget {
  const DadosConsulta({
    Key? key,
  }) : super(key: key);

  @override
  State<DadosConsulta> createState() => _DadosConsultaState();
}

class _DadosConsultaState extends State<DadosConsulta> {
  final TextEditingController _descricaoController = TextEditingController();
  final TextEditingController _medicoController = TextEditingController();
  final TextEditingController _cepController = TextEditingController();
  final TextEditingController _ruaController = TextEditingController();
  final TextEditingController _bairroController = TextEditingController();
  final TextEditingController _numeroRuaController = TextEditingController();
  final TextEditingController _complementoRuaController =
      TextEditingController();
  final TextEditingController _cidadeController = TextEditingController();
  final TextEditingController _estadoController = TextEditingController();
  final TextEditingController _observacaoController = TextEditingController();

  @override
  void initState() {
    _descricaoController.addListener(() {});

    _medicoController.addListener(() {});

    _observacaoController.addListener(() {});

    _ruaController.addListener(() {});
    _bairroController.addListener(() {});
    _numeroRuaController.addListener(() {});
    _complementoRuaController.addListener(() {});
    _cidadeController.addListener(() {});
    _estadoController.addListener(() {});
    _cepController.addListener(() {});
    super.initState();
  }

  @override
  void dispose() {
    _descricaoController.dispose();
    _observacaoController.dispose();
    _medicoController.dispose();
    _ruaController.dispose();
    _bairroController.dispose();
    _numeroRuaController.dispose();
    _complementoRuaController.dispose();
    _cidadeController.dispose();
    _estadoController.dispose();
    _cepController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: ConsultaController(),
      builder: (context, state, _) {
        if (state is ConsultaSuccessState) {
          _descricaoController.text = state.consulta.descricao;
          _medicoController.text = state.consulta.medico;
          _observacaoController.text = state.consulta.observacao;
          _ruaController.text = state.consulta.rua;
          _bairroController.text = state.consulta.bairro;
          _numeroRuaController.text = state.consulta.numeroRua;
          _complementoRuaController.text = state.consulta.complementoRua;
          _cidadeController.text = state.consulta.cidade;
          _estadoController.text = state.consulta.estado;
          _cepController.text = state.consulta.cep;
        }
        return SingleChildScrollView(
          child: Column(
            children: [
              FormCadastro(
                obrigatorio: true,
                textInputType: TextInputType.name,
                enabled: true,
                controller: _descricaoController,
                labelText: 'Descrição',
              ),
              FormCadastro(
                obrigatorio: true,
                textInputType: TextInputType.name,
                enabled: true,
                controller: _medicoController,
                labelText: 'Médico',
              ),
              FormCadastro(
                obrigatorio: true,
                textInputType: TextInputType.name,
                enabled: true,
                controller: _observacaoController,
                labelText: 'Observação',
              ),
              FormCadastro(
                enabled: true,
                controller: _cepController,
                labelText: 'CEP',
                hintText: '000000-000',
                inputFormatters: [
                  MaskTextInputFormatter(
                    mask: '#####-###',
                    filter: {'#': RegExp(r'[0-9]')},
                  ),
                ],
                textInputType: TextInputType.text,
              ),
              FormCadastro(
                obrigatorio: true,
                enabled: true,
                controller: _ruaController,
                labelText: 'Endereço',
                textInputType: TextInputType.text,
              ),
              FormCadastro(
                enabled: true,
                controller: _numeroRuaController,
                labelText: 'Complemento',
                textInputType: TextInputType.text,
              ),
              FormCadastro(
                obrigatorio: true,
                enabled: true,
                controller: _bairroController,
                labelText: 'Bairro',
                textInputType: TextInputType.text,
              ),
              FormCadastro(
                obrigatorio: true,
                enabled: true,
                controller: _cidadeController,
                labelText: 'Cidade',
                textInputType: TextInputType.text,
              ),
              FormCadastro(
                obrigatorio: true,
                enabled: true,
                controller: _estadoController,
                labelText: 'Estado',
                textInputType: TextInputType.text,
              ),
            ],
          ),
        );
      },
    );
  }
}
