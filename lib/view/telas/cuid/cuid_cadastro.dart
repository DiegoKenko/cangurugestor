import 'package:cangurugestor/view/componentes/form_cadastro.dart';
import 'package:cangurugestor/view/componentes/form_cadastro_data.dart';
import 'package:cangurugestor/view/componentes/item_container.dart';
import 'package:cangurugestor/view/componentes/styles.dart';
import 'package:cangurugestor/utils/cep_api.dart';
import 'package:cangurugestor/view/componentes/tab.dart';
import 'package:cangurugestor/viewModel/bloc_gestor.dart';
import 'package:cangurugestor/viewModel/bloc_cuidador.dart';
import 'package:cangurugestor/bloc/bloc_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';

class CadastroCuidador extends StatefulWidget {
  const CadastroCuidador({
    Key? key,
  }) : super(key: key);

  @override
  State<CadastroCuidador> createState() => _CadastroCuidadorState();
}

class _CadastroCuidadorState extends State<CadastroCuidador>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 1, vsync: this, initialIndex: 0);
    _tabController.addListener(() {
      if (context.read<AuthBloc>().state.login.editaCuidador) {
        context.read<CuidadorBloc>().add(CuidadorUpdateEvent());
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CuidadorBloc, CuidadorState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                if (state.cuidador.nome.isEmpty) {
                  Navigator.of(context).pop();
                  return;
                }
                if (context.read<AuthBloc>().state.login.editaCuidador) {
                  context.read<CuidadorBloc>().add(CuidadorUpdateEvent());
                }
                Navigator.of(context).pop();
              },
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
            title: Column(
              children: [
                Text(
                  state.cuidador.nome.toUpperCase(),
                  style: kTitleAppBarStyle,
                ),
                Text(
                  'cuidador',
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
                /*    Tab(
                  child: Text(
                    'Pacientes',
                  ),
                ), */
              ],
              views: const [
                Tab(
                  child: DadosCuidador(),
                ),
                //Tab(child: PacientesCuidador()),
              ],
            ),
          ),
        );
      },
    );
  }
}

/* class PacientesCuidador extends StatelessWidget {
  const PacientesCuidador({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CuidadorBloc cuidadorBloc = context.watch<CuidadorBloc>();
    return BlocBuilder<CuidadorBloc, CuidadorState>(
      bloc: cuidadorBloc,
      builder: (context, state) {
        return ListView.builder(
          itemCount: state.cuidador.pacientes.length,
          itemBuilder: (context, index) {
            return ItemContainer(
              title: state.cuidador.pacientes[index].nome,
            );
          },
        );
      },
    );
  }
} */

class DadosCuidador extends StatefulWidget {
  const DadosCuidador({
    Key? key,
  }) : super(key: key);

  @override
  State<DadosCuidador> createState() => _DadosCuidadorState();
}

class _DadosCuidadorState extends State<DadosCuidador> {
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
    _cpfController.addListener(() {
      // Listener para atualizar o CPF do responsável
      context.read<CuidadorBloc>().state.cuidador.cpf = _cpfController.text;
    });
    _nomeController.addListener(() {
      // Listener para atualizar o nome do responsável
      context.read<CuidadorBloc>().state.cuidador.nome = _nomeController.text;
    });
    _nascimentoController.addListener(() {
      // Listener para atualizar a data de nascimento do responsável
      context.read<CuidadorBloc>().state.cuidador.nascimento =
          _nascimentoController.text;
    });
    _emailController.addListener(() {
      // Listener para atualizar o email do responsável
      context.read<CuidadorBloc>().state.cuidador.email = _emailController.text;
    });
    _telefoneController.addListener(() {
      // Listener para atualizar o telefone do responsável
      context.read<CuidadorBloc>().state.cuidador.telefone =
          _telefoneController.text;
    });

    _numeroRuaController.addListener(() {
      // Listener para atualizar o número da rua do responsável
      context.read<CuidadorBloc>().state.cuidador.numeroRua =
          _numeroRuaController.text;
    });

    _cepController.addListener(() async {
      // Listener para atualizar o CEP do responsável
      context.read<CuidadorBloc>().state.cuidador.cep = _cepController.text;
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
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: BlocBuilder<CuidadorBloc, CuidadorState>(
        builder: (context, state) {
          _cpfController.text = state.cuidador.cpf;
          _nomeController.text = state.cuidador.nome;
          _nascimentoController.text = state.cuidador.nascimento;
          _emailController.text = state.cuidador.email;
          _telefoneController.text = state.cuidador.telefone;
          _cepController.text = state.cuidador.cep;
          _ruaController.text = state.cuidador.rua;
          _bairroController.text = state.cuidador.bairro;
          _numeroRuaController.text = state.cuidador.numeroRua;
          _cidadeController.text = state.cuidador.cidade;
          _estadoController.text = state.cuidador.estado;
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
