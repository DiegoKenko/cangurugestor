import 'package:cangurugestor/global.dart';
import 'package:cangurugestor/model/tarefa.dart';
import 'package:cangurugestor/utils/cep_api.dart';
import 'package:cangurugestor/view/componentes/adicionar_botao_rpc.dart';
import 'package:cangurugestor/view/componentes/form_cadastro.dart';
import 'package:cangurugestor/view/componentes/item_container_tarefa.dart';
import 'package:cangurugestor/view/componentes/popup_tarefa.dart';
import 'package:cangurugestor/view/componentes/styles.dart';
import 'package:cangurugestor/view/componentes/tab.dart';
import 'package:cangurugestor/viewModel/provider_consulta.dart';
import 'package:cangurugestor/viewModel/bloc_auth.dart';
import 'package:cangurugestor/viewModel/provider_paciente.dart';
import 'package:cangurugestor/viewModel/provider_tarefas.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';

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

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (context.read<AuthBloc>().state.login.editaConsulta) {
        context.read<ConsultaProvider>().update();
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
    final ConsultaProvider consultaProvider = context.watch<ConsultaProvider>();
    final PacienteProvider pacienteProvider = context.watch<PacienteProvider>();
    consultaProvider.consulta.paciente = pacienteProvider.paciente;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.read<AuthBloc>().state.login.editaConsulta) {
              consultaProvider.update();
            }
            context.read<TarefasProvider>().clear();
            consultaProvider.clear();
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              consultaProvider.delete();
              consultaProvider.clear();
              Navigator.of(context).pop();
            },
          ),
        ],
        centerTitle: true,
        title: Column(
          children: [
            Text(
              consultaProvider.consulta.descricao.toUpperCase(),
              style: kTitleAppBarStyle,
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
    final TarefasProvider tarefasProvider = context.watch<TarefasProvider>();
    tarefasProvider.paciente = context.read<PacienteProvider>().paciente;
    tarefasProvider.tipo = EnumTarefa.consulta;
    tarefasProvider.idItem = context.read<ConsultaProvider>().consulta.id;

    return Align(
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
        child: Builder(
          builder: (context) {
            tarefasProvider.load();
            var widgetTarefaSalvas = tarefasProvider.tarefas
                .map(
                  (Tarefa tarefa) => ItemContainerTarefa(
                    tarefa: tarefa,
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => PopUpTarefa(
                          tarefa: tarefa,
                        ),
                      );
                    },
                  ),
                )
                .toList();
            if (context.read<AuthBloc>().state.login.editaConsulta) {
              return Column(
                children: [
                  ...widgetTarefaSalvas,
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: BotaoCadastro(
                      onPressed: () {
                        tarefasProvider.novaTarefaConsulta(
                          context.read<ConsultaProvider>().consulta,
                        );
                      },
                    ),
                  ),
                ],
              );
            } else {
              return Column(
                children: widgetTarefaSalvas,
              );
            }
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
    _descricaoController.addListener(() {
      // Listener para atualizar a descrição da consulta
      context.read<ConsultaProvider>().consulta.descricao =
          _descricaoController.text;
    });

    _medicoController.addListener(() {
      // Listener para atualizar o médico da consulta
      context.read<ConsultaProvider>().consulta.medico = _medicoController.text;
    });

    _observacaoController.addListener(() {
      // Listener para atualizar a observação da consulta
      context.read<ConsultaProvider>().consulta.observacao =
          _observacaoController.text;
    });

    _ruaController.addListener(() {
      // Listener para atualizar a rua do responsável
      context.read<ConsultaProvider>().consulta.rua = _ruaController.text;
    });
    _bairroController.addListener(() {
      // Listener para atualizar o bairro do responsável
      context.read<ConsultaProvider>().consulta.bairro = _bairroController.text;
    });
    _numeroRuaController.addListener(() {
      // Listener para atualizar o número da rua do responsável
      context.read<ConsultaProvider>().consulta.numeroRua =
          _numeroRuaController.text;
    });
    _complementoRuaController.addListener(() {
      // Listener para atualizar o complemento da rua do responsável
      context.read<ConsultaProvider>().consulta.complementoRua =
          _complementoRuaController.text;
    });
    _cidadeController.addListener(() {
      // Listener para atualizar a cidade do responsável
      context.read<ConsultaProvider>().consulta.cidade = _cidadeController.text;
    });
    _estadoController.addListener(() {
      // Listener para atualizar o estado do responsável
      context.read<ConsultaProvider>().consulta.estado = _estadoController.text;
    });
    _cepController.addListener(() {
      // Listener para atualizar o CEP do responsável
      context.read<ConsultaProvider>().consulta.cep = _cepController.text;
      // Listener para atualizar os campos de endereço
      if (_cepController.text.length == 9) {
        CepAPI.getCep(_cepController.text).then((value) {
          if (value['cep'] != null) {
            _ruaController.text = value['logradouro'];
            _bairroController.text = value['bairro'];
            _cidadeController.text = value['localidade'];
            _estadoController.text = value['uf'];
            context.read<ConsultaProvider>().consulta.rua = value['logradouro'];
            context.read<ConsultaProvider>().consulta.bairro = value['bairro'];
            context.read<ConsultaProvider>().consulta.cidade =
                value['localidade'];
            context.read<ConsultaProvider>().consulta.estado = value['uf'];

            return;
          } else {
            _ruaController.text = '';
            _bairroController.text = '';
            _cidadeController.text = '';
            _estadoController.text = '';
          }
        });
      }
    });
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
    final ConsultaProvider consultaProvider = context.watch<ConsultaProvider>();
    _descricaoController.text = consultaProvider.consulta.descricao;
    _medicoController.text = consultaProvider.consulta.medico;
    _observacaoController.text = consultaProvider.consulta.observacao;
    _ruaController.text = consultaProvider.consulta.rua;
    _bairroController.text = consultaProvider.consulta.bairro;
    _numeroRuaController.text = consultaProvider.consulta.numeroRua;
    _complementoRuaController.text = consultaProvider.consulta.complementoRua;
    _cidadeController.text = consultaProvider.consulta.cidade;
    _estadoController.text = consultaProvider.consulta.estado;
    _cepController.text = consultaProvider.consulta.cep;

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
              )
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
  }
}
