import 'package:cangurugestor/global.dart';
import 'package:cangurugestor/model/tarefa.dart';
import 'package:cangurugestor/view/componentes/adicionar_botao_rpc.dart';
import 'package:cangurugestor/view/componentes/form_cadastro.dart';
import 'package:cangurugestor/view/componentes/form_cadastro_data.dart';
import 'package:cangurugestor/view/componentes/form_dropdown.dart';
import 'package:cangurugestor/view/componentes/item_container.dart';
import 'package:cangurugestor/view/componentes/popup_tarefa.dart';
import 'package:cangurugestor/view/componentes/styles.dart';
import 'package:cangurugestor/view/componentes/tab.dart';
import 'package:cangurugestor/viewModel/provider_login.dart';
import 'package:cangurugestor/viewModel/provider_medicamento.dart';
import 'package:cangurugestor/viewModel/provider_paciente.dart';
import 'package:cangurugestor/viewModel/provider_tarefas.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CadastroMedicamento extends StatefulWidget {
  const CadastroMedicamento({
    Key? key,
  }) : super(key: key);

  @override
  State<CadastroMedicamento> createState() => _CadastroMedicamentoState();
}

class _CadastroMedicamentoState extends State<CadastroMedicamento>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (context.read<MedicamentoProvider>().paciente.id.isEmpty) {
        context.read<MedicamentoProvider>().update();
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
    final MedicamentoProvider medicamentoProvider =
        context.watch<MedicamentoProvider>();
    final PacienteProvider pacienteProvider = context.watch<PacienteProvider>();

    return Builder(builder: (context) {
      medicamentoProvider.setPaciente(pacienteProvider.paciente);
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              medicamentoProvider.update();
              medicamentoProvider.clear();
              Navigator.pop(context);
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                medicamentoProvider.delete();
                medicamentoProvider.clear();
                Navigator.of(context).pop();
              },
            ),
          ],
          centerTitle: true,
          title: Column(
            children: [
              Text(
                medicamentoProvider.medicamento.nome.toUpperCase(),
                style: kTitleAppBarStyle,
              ),
              Text(
                'medicamento',
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
                  child: DadosMedicamento(),
                ),
                Tab(
                  child: TarefasMedicamento(),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

class TarefasMedicamento extends StatefulWidget {
  const TarefasMedicamento({
    Key? key,
  }) : super(key: key);

  @override
  State<TarefasMedicamento> createState() => _TarefasMedicamentoState();
}

class _TarefasMedicamentoState extends State<TarefasMedicamento> {
  @override
  Widget build(BuildContext context) {
    final TarefasProvider tarefasProvider = context.watch<TarefasProvider>();
    tarefasProvider.paciente = context.read<PacienteProvider>().paciente;
    tarefasProvider.tipo = EnumTarefa.medicamento;
    tarefasProvider.idItem = context.read<MedicamentoProvider>().medicamento.id;

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
          if (context.read<LoginProvider>().editMedicamento) {
            return Column(
              children: [
                ...widgetTarefaSalvas,
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: BotaoCadastro(
                    onPressed: () {
                      tarefasProvider.novaTarefaMedicamento(
                          context.read<MedicamentoProvider>().medicamento);
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
        }),
      ),
    );
  }
}

class DadosMedicamento extends StatefulWidget {
  const DadosMedicamento({
    Key? key,
  }) : super(key: key);

  @override
  State<DadosMedicamento> createState() => _DadosMedicamentoState();
}

class _DadosMedicamentoState extends State<DadosMedicamento> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _doseController = TextEditingController();
  final TextEditingController _intervaloQtdeController =
      TextEditingController();
  final TextEditingController _intervaloUMController = TextEditingController();
  final TextEditingController _inicioController = TextEditingController();
  final TextEditingController _observacaoController = TextEditingController();

  @override
  void initState() {
    _nomeController.addListener(() {
      context.read<MedicamentoProvider>().medicamento.nome =
          _nomeController.text;
    });
    _doseController.addListener(() {
      context.read<MedicamentoProvider>().medicamento.dose = double.parse(
          _doseController.text.isEmpty ? '0' : _doseController.text);
    });
    _intervaloQtdeController.addListener(() {
      context.read<MedicamentoProvider>().medicamento.intervaloQuantidade =
          double.parse(_intervaloQtdeController.text.isEmpty
              ? '0'
              : _intervaloQtdeController.text);
    });
    _intervaloUMController.addListener(() {
      context.read<MedicamentoProvider>().medicamento.intervalo =
          EnumIntervalo.values.firstWhere(
              (EnumIntervalo element) =>
                  element.name == _intervaloUMController.text,
              orElse: () => EnumIntervalo.minutos);
    });
    _inicioController.addListener(() {
      context.read<MedicamentoProvider>().medicamento.dataInicio =
          DateFormat('dd/MM/yyyy').parse(_inicioController.text.isEmpty
              ? '01/01/2023'
              : _inicioController.text);
    });
    _observacaoController.addListener(() {
      context.read<MedicamentoProvider>().medicamento.observacao =
          _observacaoController.text;
    });
    super.initState();
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _doseController.dispose();
    _intervaloQtdeController.dispose();
    _intervaloUMController.dispose();
    _inicioController.dispose();
    _observacaoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final MedicamentoProvider medicamentoProvider =
        context.watch<MedicamentoProvider>();
    _nomeController.text = medicamentoProvider.medicamento.nome;
    _doseController.text = medicamentoProvider.medicamento.dose.toString();
    _intervaloQtdeController.text =
        medicamentoProvider.medicamento.intervaloQuantidade.toString();
    _intervaloUMController.text =
        medicamentoProvider.medicamento.intervalo.name.isEmpty
            ? EnumIntervalo.minutos.name
            : medicamentoProvider.medicamento.intervalo.name;
    _inicioController.text = DateFormat('dd/MM/yyyy').format(
        medicamentoProvider.medicamento.dataInicio == null
            ? DateTime.now()
            : medicamentoProvider.medicamento.dataInicio!);
    _observacaoController.text = medicamentoProvider.medicamento.observacao;
    return SingleChildScrollView(
      child: Column(
        children: [
          FormCadastro(
            obrigatorio: true,
            textInputType: TextInputType.name,
            enabled: true,
            controller: _nomeController,
            labelText: 'Nome',
          ),
          FormCadastro(
            obrigatorio: true,
            textInputType: TextInputType.number,
            enabled: true,
            controller: _doseController,
            labelText: 'Dose',
          ),
          Row(
            children: [
              Expanded(
                child: FormCadastro(
                  obrigatorio: true,
                  textInputType: TextInputType.number,
                  enabled: true,
                  controller: _intervaloQtdeController,
                  labelText: 'a cada:',
                ),
              ),
              Expanded(
                child: FormDropDown(
                  lista: EnumIntervalo.values
                      .map((e) => e.name)
                      .toList(growable: false),
                  controller: _intervaloUMController,
                  value: medicamentoProvider.medicamento.intervalo.name,
                  hintText: 'Intervalo',
                ),
              ),
            ],
          ),
          FormCadastroData(
            dataInicial: DateTime.now(),
            dataUltima: DateTime(DateTime.now().year + 50),
            dataPrimeira: DateTime.now(),
            enabled: true,
            controller: _inicioController,
            labelText: 'Data de Início',
          ),
          FormCadastro(
            obrigatorio: true,
            textInputType: TextInputType.name,
            enabled: true,
            multiLine: true,
            controller: _observacaoController,
            labelText: 'Observação',
          ),
        ],
      ),
    );
  }
}
