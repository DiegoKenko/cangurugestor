import 'package:cangurugestor/view/componentes/form_cadastro.dart';
import 'package:cangurugestor/view/componentes/form_cadastro_data_hora.dart';
import 'package:cangurugestor/view/componentes/tab.dart';
import 'package:cangurugestor/viewModel/provider_consulta.dart';
import 'package:cangurugestor/viewModel/provider_paciente.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
  final TextEditingController _descricaoController = TextEditingController();
  final TextEditingController _observacaoController = TextEditingController();
  final TextEditingController _responsavelController = TextEditingController();
  final TextEditingController _medicoController = TextEditingController();
  final TextEditingController _ruaController = TextEditingController();
  final TextEditingController _numeroController = TextEditingController();
  final TextEditingController _bairroController = TextEditingController();
  final TextEditingController _cidadeController = TextEditingController();
  final TextEditingController _estadoController = TextEditingController();
  final TextEditingController _cepController = TextEditingController();
  final TextEditingController _complementoRuaController =
      TextEditingController();
  final TextEditingController _dataConsultaController = TextEditingController();
  final TextEditingController _horaConsultaController = TextEditingController();
  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    _descricaoController.addListener(() {
      context.read<ConsultaProvider>().consulta.descricao =
          _descricaoController.text;
    });
    _observacaoController.addListener(() {
      context.read<ConsultaProvider>().consulta.observacao =
          _observacaoController.text;
    });
    _responsavelController.addListener(() {
      context.read<ConsultaProvider>().consulta.responsavel =
          _responsavelController.text;
    });
    _medicoController.addListener(() {
      context.read<ConsultaProvider>().consulta.medico = _medicoController.text;
    });
    _ruaController.addListener(() {
      context.read<ConsultaProvider>().consulta.rua = _ruaController.text;
    });
    _numeroController.addListener(() {
      context.read<ConsultaProvider>().consulta.numero = _numeroController.text;
    });
    _bairroController.addListener(() {
      context.read<ConsultaProvider>().consulta.bairro = _bairroController.text;
    });
    _cidadeController.addListener(() {
      context.read<ConsultaProvider>().consulta.cidade = _cidadeController.text;
    });
    _estadoController.addListener(() {
      context.read<ConsultaProvider>().consulta.estado = _estadoController.text;
    });
    _cepController.addListener(() {
      context.read<ConsultaProvider>().consulta.cep = _cepController.text;
    });
    _complementoRuaController.addListener(() {
      context.read<ConsultaProvider>().consulta.complementoRua =
          _complementoRuaController.text;
    });
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _descricaoController.dispose();
    _observacaoController.dispose();
    _responsavelController.dispose();
    _medicoController.dispose();
    _ruaController.dispose();
    _numeroController.dispose();
    _bairroController.dispose();
    _cidadeController.dispose();
    _estadoController.dispose();
    _cepController.dispose();
    _complementoRuaController.dispose();
    _dataConsultaController.dispose();
    _horaConsultaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ConsultaProvider consultaProvider = context.watch<ConsultaProvider>();
    final PacienteProvider pacienteProvider = context.watch<PacienteProvider>();
    _descricaoController.text = consultaProvider.consulta.descricao;
    _observacaoController.text = consultaProvider.consulta.observacao;
    _responsavelController.text = consultaProvider.consulta.responsavel;
    _medicoController.text = consultaProvider.consulta.medico;
    _ruaController.text = consultaProvider.consulta.rua;
    _numeroController.text = consultaProvider.consulta.numero;
    _bairroController.text = consultaProvider.consulta.bairro;
    _cidadeController.text = consultaProvider.consulta.cidade;
    _estadoController.text = consultaProvider.consulta.estado;
    _cepController.text = consultaProvider.consulta.cep;
    _complementoRuaController.text = consultaProvider.consulta.complementoRua;
    _dataConsultaController.text =
        DateFormat('dd/MM/yyyy').format(consultaProvider.consulta.dataConsulta);

    return Builder(builder: (context) {
      consultaProvider.setPaciente(pacienteProvider.paciente);
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              consultaProvider.update();
              consultaProvider.clear();
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
                              consultaProvider.consulta.descricao = value;
                            },
                            enabled: true,
                            controller: _descricaoController,
                            labelText: 'Descrição',
                          ),
                          FormCadastro(
                            obrigatorio: false,
                            textInputType: TextInputType.name,
                            onChanged: (value) {
                              consultaProvider.consulta.observacao = value;
                            },
                            enabled: true,
                            controller: _observacaoController,
                            labelText: 'Observação',
                          ),
                          FormCadastro(
                            obrigatorio: true,
                            textInputType: TextInputType.name,
                            onChanged: (value) {
                              consultaProvider.consulta.responsavel = value;
                            },
                            enabled: true,
                            controller: _responsavelController,
                            labelText: 'Responsável',
                          ),
                          FormCadastro(
                            obrigatorio: true,
                            textInputType: TextInputType.name,
                            onChanged: (value) {
                              consultaProvider.consulta.medico = value;
                            },
                            enabled: true,
                            controller: _medicoController,
                            labelText: 'Médico',
                          ),
                          FormCadastro(
                            obrigatorio: true,
                            textInputType: TextInputType.name,
                            onChanged: (value) {
                              consultaProvider.consulta.rua = value;
                            },
                            enabled: true,
                            controller: _ruaController,
                            labelText: 'Rua',
                          ),
                          FormCadastro(
                            obrigatorio: true,
                            textInputType: TextInputType.number,
                            onChanged: (value) {
                              consultaProvider.consulta.numero = value;
                            },
                            enabled: true,
                            controller: _numeroController,
                            labelText: 'Número',
                          ),
                          FormCadastro(
                            obrigatorio: true,
                            textInputType: TextInputType.name,
                            onChanged: (value) {
                              consultaProvider.consulta.bairro = value;
                            },
                            enabled: true,
                            controller: _bairroController,
                            labelText: 'Bairro',
                          ),
                          FormCadastro(
                            obrigatorio: true,
                            textInputType: TextInputType.name,
                            onChanged: (value) {
                              consultaProvider.consulta.cidade = value;
                            },
                            enabled: true,
                            controller: _cidadeController,
                            labelText: 'Cidade',
                          ),
                          FormCadastro(
                            obrigatorio: true,
                            textInputType: TextInputType.name,
                            onChanged: (value) {
                              consultaProvider.consulta.estado = value;
                            },
                            enabled: true,
                            controller: _estadoController,
                            labelText: 'Estado',
                          ),
                          FormCadastro(
                            obrigatorio: true,
                            textInputType: TextInputType.number,
                            onChanged: (value) {
                              consultaProvider.consulta.cep = value;
                            },
                            enabled: true,
                            controller: _cepController,
                            labelText: 'CEP',
                          ),
                          FormCadastro(
                            obrigatorio: false,
                            textInputType: TextInputType.name,
                            onChanged: (value) {
                              consultaProvider.consulta.complementoRua = value;
                            },
                            enabled: true,
                            controller: _complementoRuaController,
                            labelText: 'Complemento',
                          ),
                          FormCadastroDataHora(
                            onDismissed: ((p0) {}),
                            controllerHora: _horaConsultaController,
                            controllerData: _dataConsultaController,
                            enabled: true,
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
