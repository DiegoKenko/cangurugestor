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
import 'package:cangurugestor/viewModel/provider_gestor.dart';
import 'package:cangurugestor/viewModel/provider_login.dart';
import 'package:cangurugestor/viewModel/provider_paciente.dart';
import 'package:cangurugestor/viewModel/provider_responsavel.dart';
import 'package:flutter/material.dart';
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ResponsavelProvider responsavelProvider =
        context.watch<ResponsavelProvider>();
    final GestorProvider gestorProvider = context.watch<GestorProvider>();
    responsavelProvider.setGestor(gestorProvider.gestor);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.read<LoginProvider>().editResponsavel) {
              responsavelProvider.update();
            }
            responsavelProvider.clear();
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              context.read<ResponsavelProvider>().delete(
                    responsavelProvider.responsavel.gestor,
                    responsavelProvider.responsavel,
                  );
              Navigator.of(context).pop();
            },
          ),
        ],
        title: Column(
          children: [
            Text(
              responsavelProvider.responsavel.nome.toUpperCase(),
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
  }
}

class PacientesResponsavel extends StatelessWidget {
  const PacientesResponsavel({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ResponsavelProvider responsavelProvider =
        context.watch<ResponsavelProvider>();
    return Column(
      children: [
        Builder(
          builder: (context) {
            responsavelProvider.loadPacientes();
            if (responsavelProvider.responsavel.pacientes.isEmpty) {
              return const Expanded(
                child: Center(
                  child: Text('nenhum paciente cadastrado'),
                ),
              );
            } else {
              return Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: responsavelProvider.responsavel.pacientes.length,
                  itemBuilder: (context, index) {
                    return ItemContainer(
                      leading: const CircleAvatar(
                        backgroundImage: AssetImage('assets/avatar.png'),
                      ),
                      onTap: () {
                        context.read<PacienteProvider>().paciente =
                            responsavelProvider.responsavel.pacientes[index];
                        Navigator.of(context).push(
                          AnimatedPageTransition(
                            page: const CadastroPaciente(),
                          ),
                        );
                      },
                      title:
                          responsavelProvider.responsavel.pacientes[index].nome,
                    );
                  },
                ),
              );
            }
          },
        ),
        SizedBox(
          height: 50,
          child: Center(
            child: BotaoCadastro(
              onPressed: () {
                context.read<PacienteProvider>().paciente = Paciente();
                Navigator.of(context).push(
                  AnimatedPageTransition(
                    page: const CadastroPaciente(),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
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
  final TextEditingController _complementoRuaController =
      TextEditingController();
  final TextEditingController _cidadeController = TextEditingController();
  final TextEditingController _estadoController = TextEditingController();

  @override
  void initState() {
    _cpfController.addListener(() {
      // Listener para atualizar o CPF do responsável
      context.read<ResponsavelProvider>().responsavel.cpf = _cpfController.text;
    });
    _nomeController.addListener(() {
      // Listener para atualizar o nome do responsável
      context.read<ResponsavelProvider>().responsavel.nome =
          _nomeController.text;
    });
    _nascimentoController.addListener(() {
      // Listener para atualizar a data de nascimento do responsável
      context.read<ResponsavelProvider>().responsavel.nascimento =
          _nascimentoController.text;
    });
    _emailController.addListener(() {
      // Listener para atualizar o email do responsável
      context.read<ResponsavelProvider>().responsavel.email =
          _emailController.text;
    });
    _telefoneController.addListener(() {
      // Listener para atualizar o telefone do responsável
      context.read<ResponsavelProvider>().responsavel.telefone =
          _telefoneController.text;
    });

    _ruaController.addListener(() {
      // Listener para atualizar a rua do responsável
      context.read<ResponsavelProvider>().responsavel.rua = _ruaController.text;
    });
    _bairroController.addListener(() {
      // Listener para atualizar o bairro do responsável
      context.read<ResponsavelProvider>().responsavel.bairro =
          _bairroController.text;
    });
    _numeroRuaController.addListener(() {
      // Listener para atualizar o número da rua do responsável
      context.read<ResponsavelProvider>().responsavel.numeroRua =
          _numeroRuaController.text;
    });
    _complementoRuaController.addListener(() {
      // Listener para atualizar o complemento da rua do responsável
      context.read<ResponsavelProvider>().responsavel.complementoRua =
          _complementoRuaController.text;
    });
    _cidadeController.addListener(() {
      // Listener para atualizar a cidade do responsável
      context.read<ResponsavelProvider>().responsavel.cidade =
          _cidadeController.text;
    });
    _estadoController.addListener(() {
      // Listener para atualizar o estado do responsável
      context.read<ResponsavelProvider>().responsavel.estado =
          _estadoController.text;
    });
    _cepController.addListener(() {
      // Listener para atualizar o CEP do responsável
      context.read<ResponsavelProvider>().responsavel.cep = _cepController.text;
      // Listener para atualizar os campos de endereço
      if (_cepController.text.length == 9) {
        CepAPI.getCep(_cepController.text).then((value) {
          if (value['cep'] != null) {
            _ruaController.text = value['logradouro'];
            _bairroController.text = value['bairro'];
            _cidadeController.text = value['localidade'];
            _estadoController.text = value['uf'];
            context.read<ResponsavelProvider>().responsavel.rua =
                value['logradouro'];
            context.read<ResponsavelProvider>().responsavel.bairro =
                value['bairro'];
            context.read<ResponsavelProvider>().responsavel.cidade =
                value['localidade'];
            context.read<ResponsavelProvider>().responsavel.estado =
                value['uf'];

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
    _cpfController.dispose();
    _nomeController.dispose();
    _nascimentoController.dispose();
    _emailController.dispose();
    _telefoneController.dispose();
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
    final ResponsavelProvider responsavelProvider =
        context.watch<ResponsavelProvider>();
    _cpfController.text = responsavelProvider.responsavel.cpf;
    _nomeController.text = responsavelProvider.responsavel.nome;
    _nascimentoController.text = responsavelProvider.responsavel.nascimento;
    _emailController.text = responsavelProvider.responsavel.email;
    _telefoneController.text = responsavelProvider.responsavel.telefone;
    _cepController.text = responsavelProvider.responsavel.cep;
    _ruaController.text = responsavelProvider.responsavel.rua;
    _bairroController.text = responsavelProvider.responsavel.bairro;
    _numeroRuaController.text = responsavelProvider.responsavel.numeroRua;
    _complementoRuaController.text =
        responsavelProvider.responsavel.complementoRua;
    _cidadeController.text = responsavelProvider.responsavel.cidade;
    _estadoController.text = responsavelProvider.responsavel.estado;

    return SingleChildScrollView(
      child: Form(
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Text(
                    'Ativo',
                    style: TextStyle(color: corPad1, fontSize: 15),
                  ),
                ),
                Switch(
                  value: responsavelProvider.responsavel.ativo,
                  onChanged: (value) {
                    responsavelProvider.responsavel.ativo = value;
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
