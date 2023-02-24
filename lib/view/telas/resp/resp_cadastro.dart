import 'package:cangurugestor/model/paciente.dart';
import 'package:cangurugestor/view/componentes/adicionar_botao_rpc.dart';
import 'package:cangurugestor/view/componentes/animated_page_transition.dart';
import 'package:cangurugestor/view/componentes/form_cadastro.dart';
import 'package:cangurugestor/view/componentes/form_cadastro_data.dart';
import 'package:cangurugestor/view/componentes/item_container.dart';
import 'package:cangurugestor/view/componentes/styles.dart';
import 'package:cangurugestor/utils/cep_api.dart';
import 'package:cangurugestor/view/componentes/tab.dart';
import 'package:cangurugestor/view/telas/paci/paci_cadastro.dart';
import 'package:cangurugestor/viewModel/bloc_gestor.dart';
import 'package:cangurugestor/bloc/bloc_auth.dart';
import 'package:cangurugestor/viewModel/bloc_paciente.dart';
import 'package:cangurugestor/viewModel/bloc_responsavel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';

class CadastroResponsavel extends StatefulWidget {
  const CadastroResponsavel({
    Key? key,
  }) : super(key: key);

  @override
  State<CadastroResponsavel> createState() => _CadastroResponsavelState();
}

class _CadastroResponsavelState extends State<CadastroResponsavel>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this, initialIndex: 0);
    _tabController.addListener(() {
      if (context.read<AuthBloc>().state.login.editaResponsavel) {
        context.read<ResponsavelBloc>().add(ResponsavelUpdateEvent());
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ResponsavelBloc, ResponsavelState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                if (state.responsavel.nome.isEmpty) {
                  Navigator.of(context).pop();
                  return;
                }
                if (context.read<AuthBloc>().state.login.editaResponsavel) {
                  context.read<ResponsavelBloc>().add(ResponsavelUpdateEvent());
                }
                Navigator.of(context).pop();
              },
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  context.read<ResponsavelBloc>().add(ResponsavelDeleteEvent());
                  Navigator.of(context).pop();
                },
              ),
            ],
            title: Column(
              children: [
                Text(
                  state.responsavel.nome.toUpperCase(),
                  style: kTitleAppBarStyle,
                ),
                Text(
                  'cliente',
                  style: kSubtitleAppBarStyle,
                )
              ],
            ),
          ),
          body: SafeArea(
            child: TabCanguru(
              controller: _tabController,
              tabs: const [
                Tab(
                  child: Text(
                    'Dados',
                  ),
                ),
                Tab(
                  child: Text(
                    'Pacientes',
                  ),
                ),
                Tab(
                  child: Text(
                    'Contrato',
                  ),
                ),
              ],
              views: [
                const Tab(
                  child: DadosResponsavel(),
                ),
                const Tab(child: PacientesResponsavel()),
                Tab(
                  child: SingleChildScrollView(
                    child: Column(
                      children: const [
                        Text('nenhum contrato cadastrado'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class PacientesResponsavel extends StatelessWidget {
  const PacientesResponsavel({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ResponsavelBloc, ResponsavelState>(
        builder: (context, state) {
      context.read<ResponsavelBloc>().add(ResponsavelLoadPacientesEvent());
      return Column(
        children: [
          state.responsavel.pacientes.isEmpty
              ? const Expanded(
                  child: Center(
                    child: Text('nenhum paciente cadastrado'),
                  ),
                )
              : Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: state.responsavel.pacientes.length,
                    itemBuilder: (context, index) {
                      Paciente paciente = state.responsavel.pacientes[index];
                      return ItemContainer(
                        leading: const CircleAvatar(
                          backgroundImage: AssetImage('assets/avatar.png'),
                        ),
                        onTap: () {
                          Navigator.of(context).push(
                            AnimatedPageTransition(
                              page: BlocProvider<PacienteBloc>(
                                create: (context) => PacienteBloc(paciente),
                                child: const CadastroPaciente(),
                              ),
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
                      page: BlocProvider<PacienteBloc>(
                        create: (context) => PacienteBloc(
                          Paciente.initOnAdd(
                            state.responsavel.id,
                          ),
                        ),
                        child: const CadastroPaciente(),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      );
    });
  }
}

class DadosResponsavel extends StatefulWidget {
  const DadosResponsavel({
    Key? key,
  }) : super(key: key);

  @override
  State<DadosResponsavel> createState() => _DadosResponsavelState();
}

class _DadosResponsavelState extends State<DadosResponsavel> {
  final TextEditingController _cpfController = TextEditingController();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _nascimentoController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();
  final TextEditingController _cepController = TextEditingController();
  final TextEditingController _ruaController = TextEditingController();
  final TextEditingController _bairroController = TextEditingController();
  final TextEditingController _numeroRuaController = TextEditingController();
  final TextEditingController _cidadeController = TextEditingController();
  final TextEditingController _estadoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _cpfController.addListener(() {
      // Listener para atualizar o CPF do responsável
      context.read<ResponsavelBloc>().state.responsavel.cpf =
          _cpfController.text;
    });
    _nomeController.addListener(() {
      // Listener para atualizar o nome do responsável
      context.read<ResponsavelBloc>().state.responsavel.nome =
          _nomeController.text;
    });
    _nascimentoController.addListener(() {
      // Listener para atualizar a data de nascimento do responsável
      context.read<ResponsavelBloc>().state.responsavel.nascimento =
          _nascimentoController.text;
    });
    _emailController.addListener(() {
      // Listener para atualizar o email do responsável
      context.read<ResponsavelBloc>().state.responsavel.email =
          _emailController.text;
    });
    _telefoneController.addListener(() {
      // Listener para atualizar o telefone do responsável
      context.read<ResponsavelBloc>().state.responsavel.telefone =
          _telefoneController.text;
    });

    _numeroRuaController.addListener(() {
      // Listener para atualizar o número da rua do responsável
      context.read<ResponsavelBloc>().state.responsavel.numeroRua =
          _numeroRuaController.text;
    });

    _cepController.addListener(() async {
      // Listener para atualizar o CEP do responsável
      context.read<ResponsavelBloc>().state.responsavel.cep =
          _cepController.text;
      // Listener para atualizar os campos de endereço
      if (_cepController.text.length == 9) {
        Map<dynamic, dynamic> value = await CepAPI.getCep(_cepController.text);
        if (value['cep'] != null) {
          _ruaController.text = value['logradouro'];
          _bairroController.text = value['bairro'];
          _cidadeController.text = value['localidade'];
          _estadoController.text = value['uf'];
          return;
        } else {
          _ruaController.text = '';
          _bairroController.text = '';
          _cidadeController.text = '';
          _estadoController.text = '';
        }
      }
    });
  }

  @override
  void dispose() {
    _cpfController.dispose();
    _nomeController.dispose();
    _nascimentoController.dispose();
    _emailController.dispose();
    _telefoneController.dispose();
    _ruaController.dispose();
    _bairroController.dispose();
    _numeroRuaController.dispose();
    _cidadeController.dispose();
    _estadoController.dispose();
    _cepController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: BlocBuilder<ResponsavelBloc, ResponsavelState>(
        builder: (context, state) {
          _cpfController.text = state.responsavel.cpf;
          _nomeController.text = state.responsavel.nome;
          _nascimentoController.text = state.responsavel.nascimento;
          _emailController.text = state.responsavel.email;
          _telefoneController.text = state.responsavel.telefone;
          _cepController.text = state.responsavel.cep;
          return Form(
            child: Column(
              children: [
                FormCadastro(
                  obrigatorio: true,
                  enabled: true,
                  controller: _cpfController,
                  labelText: 'CPF',
                  inputFormatters: [
                    MaskTextInputFormatter(
                      mask: '###.###.###-##',
                      filter: {'#': RegExp(r'[0-9]')},
                    )
                  ],
                  textInputType: TextInputType.phone,
                ),
                FormCadastro(
                  obrigatorio: true,
                  enabled: true,
                  controller: _nomeController,
                  labelText: 'Nome',
                  textInputType: TextInputType.text,
                ),
                FormCadastroData(
                  obrigatorio: true,
                  enabled: true,
                  dataPrimeira: DateTime(DateTime.now().year - 100),
                  dataInicial: DateTime(DateTime.now().year - 10),
                  dataUltima: DateTime(DateTime.now().year),
                  controller: _nascimentoController,
                  labelText: 'Data de nascimento',
                ),
                FormCadastro(
                  enabled: true,
                  controller: _emailController,
                  labelText: 'e-mail',
                  textInputType: TextInputType.text,
                ),
                FormCadastro(
                  enabled: true,
                  controller: _telefoneController,
                  labelText: 'Celular',
                  textInputType: TextInputType.number,
                  inputFormatters: [
                    MaskTextInputFormatter(
                      mask: '## #####-####',
                      filter: {'#': RegExp(r'[0-9]')},
                    )
                  ],
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
                FutureBuilder(
                  future: _cepController.text.isEmpty
                      ? Future.delayed(
                          const Duration(seconds: 1),
                        )
                      : CepAPI.getCep(_cepController.text),
                  builder: (context, snap) {
                    if (snap.hasData) {
                      _ruaController.text = snap.data['logradouro'];
                      _bairroController.text = snap.data['bairro'];
                      _cidadeController.text = snap.data['localidade'];
                      _estadoController.text = snap.data['uf'];
                    }
                    return Column(
                      children: [
                        FormCadastro(
                          controller: _ruaController,
                          labelText: 'Endereço',
                          textInputType: TextInputType.text,
                        ),
                        FormCadastro(
                          enabled: true,
                          controller: _numeroRuaController,
                          labelText: 'Número/complemento',
                          textInputType: TextInputType.text,
                        ),
                        FormCadastro(
                          controller: _bairroController,
                          labelText: 'Bairro',
                          textInputType: TextInputType.text,
                        ),
                        FormCadastro(
                          controller: _cidadeController,
                          labelText: 'Cidade',
                          textInputType: TextInputType.text,
                        ),
                        FormCadastro(
                          controller: _estadoController,
                          labelText: 'Estado',
                          textInputType: TextInputType.text,
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
