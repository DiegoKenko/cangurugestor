import 'package:cangurugestor/global.dart';
import 'package:cangurugestor/model/tarefa.dart';
import 'package:cangurugestor/view/componentes/adicionar_botao_rpc.dart';
import 'package:cangurugestor/view/componentes/form_cadastro.dart';
import 'package:cangurugestor/view/componentes/form_dropdown.dart';
import 'package:cangurugestor/view/componentes/item_container.dart';
import 'package:cangurugestor/view/componentes/popup_tarefa.dart';
import 'package:cangurugestor/view/componentes/styles.dart';
import 'package:cangurugestor/view/componentes/tab.dart';
import 'package:cangurugestor/viewModel/provider_atividade.dart';
import 'package:cangurugestor/viewModel/provider_paciente.dart';
import 'package:cangurugestor/viewModel/provider_tarefas.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
      if (context.read<AtividadeProvider>().atividade.id.isEmpty) {
        context.read<AtividadeProvider>().update();
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
    final AtividadeProvider atividadeProvider =
        context.watch<AtividadeProvider>();
    final PacienteProvider pacienteProvider = context.watch<PacienteProvider>();
    atividadeProvider.atividade.paciente = pacienteProvider.paciente;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            atividadeProvider.update();
            atividadeProvider.clear();
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              atividadeProvider.delete();
              atividadeProvider.clear();
              Navigator.of(context).pop();
            },
          ),
        ],
        centerTitle: true,
        title: Column(
          children: [
            Text(
              atividadeProvider.atividade.descricao.toUpperCase(),
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
    final TarefasProvider tarefasProvider = context.watch<TarefasProvider>();
    tarefasProvider.paciente = context.read<PacienteProvider>().paciente;
    tarefasProvider.tipo = EnumTarefa.atividade;
    tarefasProvider.idItem = context.read<AtividadeProvider>().atividade.id;

    return Align(
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
        child: Builder(builder: (context) {
          tarefasProvider.load();
          var widgetTarefaSalvas = tarefasProvider.tarefas
              .map((Tarefa tarefa) => ItemContainer(
                    title: '${tarefa.date} - ${tarefa.time}',
                    subtitle: tarefa.observacao,
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => PopUpTarefa(
                          tarefa: tarefa,
                        ),
                      );
                    },
                  ))
              .toList();
          return Column(
            children: [
              ...widgetTarefaSalvas,
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: BotaoCadastro(
                  onPressed: () {
                    tarefasProvider.novaTarefaAtividade(
                        context.read<AtividadeProvider>().atividade);
                  },
                ),
              ),
            ],
          );
        }),
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
      context.read<AtividadeProvider>().atividade.descricao =
          _descricaoController.text;
    });
    _localController.addListener(() {
      // Listener para atualizar a descrição da atividade
      context.read<AtividadeProvider>().atividade.local = _localController.text;
    });
    _observacaoController.addListener(() {
      // Listener para atualizar a descrição da atividade
      context.read<AtividadeProvider>().atividade.observacao =
          _observacaoController.text;
    });
    _duracaoController.addListener(() {
      // Listener para atualizar a descrição da atividade
      context.read<AtividadeProvider>().atividade.duracaoQuantidade =
          double.parse(_duracaoController.text);
    });
    _duracaoUMController.addListener(() {
      // Listener para atualizar a descrição da atividade
      context.read<AtividadeProvider>().atividade.duracaoMedida =
          EnumIntervalo.values.firstWhere(
              (EnumIntervalo element) =>
                  element.name == _duracaoUMController.text,
              orElse: () => EnumIntervalo.minutos);
    });
    _frequenciaQtdeController.addListener(() {
      // Listener para atualizar a descrição da atividade
      context.read<AtividadeProvider>().atividade.frequenciaQuantidade =
          double.parse(_frequenciaQtdeController.text);
    });
    _frequenciaUMController.addListener(() {
      // Listener para atualizar a descrição da atividade
      context.read<AtividadeProvider>().atividade.frequenciaMedida =
          EnumIntervalo.values.firstWhere(
              (EnumIntervalo element) =>
                  element.name == _frequenciaUMController.text,
              orElse: () => EnumIntervalo.minutos);
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
    final AtividadeProvider atividadeProvider =
        context.watch<AtividadeProvider>();
    _descricaoController.text = atividadeProvider.atividade.descricao;
    _localController.text = atividadeProvider.atividade.local;
    _observacaoController.text = atividadeProvider.atividade.observacao;
    _duracaoController.text =
        atividadeProvider.atividade.duracaoQuantidade.toString();
    _duracaoUMController.text = atividadeProvider.atividade.duracaoMedida.name;
    _frequenciaQtdeController.text =
        atividadeProvider.atividade.frequenciaQuantidade.toString();
    _frequenciaUMController.text =
        atividadeProvider.atividade.frequenciaMedida.name;

    return SingleChildScrollView(
      child: Column(
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
                  value: atividadeProvider.atividade.duracaoMedida.name,
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
                  value: atividadeProvider.atividade.frequenciaMedida.name,
                  hintText: 'Intervalo',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
