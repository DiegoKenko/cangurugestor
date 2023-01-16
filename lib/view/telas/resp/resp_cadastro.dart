import 'package:cangurugestor/firebaseUtils/fire_responsavel.dart';
import 'package:cangurugestor/view/componentes/animated_page_transition.dart';
import 'package:cangurugestor/view/componentes/form_cadastro.dart';
import 'package:cangurugestor/view/componentes/form_cadastro_data.dart';
import 'package:cangurugestor/view/componentes/styles.dart';
import 'package:cangurugestor/utils/cep_api.dart';
import 'package:cangurugestor/view/componentes/tab.dart';
import 'package:cangurugestor/view/telas/paci/paci_cadastro.dart';
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
  bool ativo = true;
  List<Widget> pacientesWidget = [];
  List<Widget> cuidadoresWidget = [];
  FirestoreResponsavel fireStoreResponsavel = FirestoreResponsavel();
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ResponsavelProvider responsavelProvider =
        context.watch<ResponsavelProvider>();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          responsavelProvider.responsavel.nome,
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
            Tab(child: Container()),
          ],
        ),
      ),
      bottomNavigationBar: const BottomAppBar(
        color: corPad1,
        child: SizedBox(
          height: 50,
          child: Center(),
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
        Builder(builder: (context) {
          responsavelProvider.loadPacientes();
          return Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: responsavelProvider.responsavel.pacientes.length,
              itemBuilder: (context, index) {
                return Card(
                  child: InkWell(
                    onTap: () {
                      context.read<PacienteProvider>().setPaciente(
                          responsavelProvider.responsavel.pacientes[index]);
                      Navigator.of(context).push(
                        AnimatedPageTransition(
                          page: const CadastroPaciente(),
                        ),
                      );
                    },
                    child: ListTile(
                      subtitle: Text(
                        responsavelProvider.responsavel.pacientes[index].nome,
                      ),
                      title: Text(
                        responsavelProvider.responsavel.pacientes[index].id,
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        }),
        SizedBox(
          height: 50,
          child: Center(
            child: IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
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
  final TextEditingController _senhaController = TextEditingController();
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
    _senhaController.addListener(() {
      // Listener para atualizar a senha do responsável
      context.read<ResponsavelProvider>().responsavel.senha =
          _senhaController.text;
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
    _senhaController.dispose();
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
                    mask: "###.###.###-##", filter: {"#": RegExp(r'[0-9]')})
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
                    mask: "## #####-####", filter: {"#": RegExp(r'[0-9]')})
              ],
            ),
            FormCadastro(
              enabled: true,
              controller: _cepController,
              labelText: 'CEP',
              hintText: '000000-000',
              inputFormatters: [
                MaskTextInputFormatter(
                    mask: "#####-###", filter: {"#": RegExp(r'[0-9]')})
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
                    context.read<ResponsavelProvider>().responsavel.ativo =
                        value;
                    context.read<ResponsavelProvider>().notifyListeners();
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
