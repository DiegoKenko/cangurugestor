import 'package:cangurugestor/global.dart';
import 'package:cangurugestor/view/componentes/form_cadastro.dart';
import 'package:cangurugestor/view/componentes/form_cadastro_data.dart';
import 'package:cangurugestor/view/componentes/tab.dart';
import 'package:cangurugestor/viewModel/provider_medicamento.dart';
import 'package:cangurugestor/viewModel/provider_paciente.dart';
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
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _doseController = TextEditingController();
  final TextEditingController _intervaloQtdeController =
      TextEditingController();
  final TextEditingController _intervaloUMController = TextEditingController();
  final TextEditingController _inicioController = TextEditingController();

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
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
      context.read<MedicamentoProvider>().medicamento.intervalo = EnumIntervalo
          .values
          .firstWhere((element) => element.name == _intervaloUMController.text,
              orElse: () => EnumIntervalo.minutos);
    });
    _inicioController.addListener(() {
      context.read<MedicamentoProvider>().medicamento.dataInicio =
          DateFormat('dd/MM/yyyy').parse(_inicioController.text.isEmpty
              ? '01/01/2023'
              : _inicioController.text);
    });
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _nomeController.dispose();
    _doseController.dispose();
    _intervaloQtdeController.dispose();
    _intervaloUMController.dispose();
    _inicioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final MedicamentoProvider medicamentoProvider =
        context.watch<MedicamentoProvider>();
    final PacienteProvider pacienteProvider = context.watch<PacienteProvider>();
    _nomeController.text = medicamentoProvider.medicamento.nome;
    _doseController.text = medicamentoProvider.medicamento.dose.toString();
    _intervaloQtdeController.text =
        medicamentoProvider.medicamento.intervaloQuantidade.toString();
    _intervaloUMController.text =
        medicamentoProvider.medicamento.intervalo.name;
    _inicioController.text = DateFormat('dd/MM/yyyy').format(
        medicamentoProvider.medicamento.dataInicio == null
            ? DateTime.now()
            : medicamentoProvider.medicamento.dataInicio!);

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
              views: [
                Tab(
                  child: Builder(builder: (context) {
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          FormCadastro(
                            obrigatorio: true,
                            textInputType: TextInputType.name,
                            onChanged: (value) {
                              medicamentoProvider.medicamento.nome = value;
                            },
                            enabled: true,
                            controller: _nomeController,
                            labelText: 'Nome',
                          ),
                          FormCadastro(
                            obrigatorio: true,
                            textInputType: TextInputType.number,
                            onChanged: (value) {
                              medicamentoProvider.medicamento.dose =
                                  double.parse(value.isEmpty ? '0' : value);
                            },
                            enabled: true,
                            controller: _doseController,
                            labelText: 'Dose',
                          ),
                          FormCadastro(
                            obrigatorio: true,
                            textInputType: TextInputType.number,
                            onChanged: (value) {
                              medicamentoProvider
                                      .medicamento.intervaloQuantidade =
                                  double.parse(value.isEmpty ? '0' : value);
                            },
                            enabled: true,
                            controller: _intervaloQtdeController,
                            labelText: 'Intervalo',
                          ),
                          FormCadastro(
                            obrigatorio: true,
                            onChanged: (value) {
                              medicamentoProvider.medicamento.intervalo =
                                  EnumIntervalo.values.firstWhere(
                                      (element) => element.name == value,
                                      orElse: () => EnumIntervalo.minutos);
                            },
                            enabled: true,
                            controller: _intervaloUMController,
                            labelText: 'Unidade de Medida',
                          ),
                          FormCadastroData(
                            dataInicial: DateTime.now(),
                            dataUltima: DateTime(DateTime.now().year + 50),
                            dataPrimeira: DateTime.now(),
                            enabled: true,
                            controller: _inicioController,
                            labelText: 'Data de Início',
                          ),
                        ],
                      ),
                    );
                  }),
                ),
                Tab(
                  child: Container(),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
