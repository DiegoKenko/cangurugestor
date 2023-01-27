import 'package:cangurugestor/view/componentes/form_cadastro.dart';
import 'package:cangurugestor/view/componentes/form_cadastro_data.dart';
import 'package:cangurugestor/view/componentes/item_container.dart';
import 'package:cangurugestor/view/componentes/styles.dart';
import 'package:cangurugestor/utils/cep_api.dart';
import 'package:cangurugestor/view/componentes/tab.dart';
import 'package:cangurugestor/viewModel/provider_cuidador.dart';
import 'package:cangurugestor/viewModel/provider_gestor.dart';
import 'package:cangurugestor/viewModel/provider_login.dart';
import 'package:flutter/material.dart';
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
  bool ativo = true;
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final CuidadorProvider cuidadorProvider = context.watch<CuidadorProvider>();
    final GestorProvider gestorProvider = context.watch<GestorProvider>();
    cuidadorProvider.gestor = gestorProvider.gestor;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.read<LoginProvider>().editCuidador) {
              cuidadorProvider.update().then(
                    (value) => gestorProvider
                        .addCuidadorGestor(cuidadorProvider.cuidador),
                  );
            }
            cuidadorProvider.clear();
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              context.read<CuidadorProvider>().delete();
              Navigator.of(context).pop();
            },
          ),
        ],
        title: Column(
          children: [
            Text(
              cuidadorProvider.cuidador.nome.toUpperCase(),
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
            Tab(
              child: Text(
                'Pacientes',
              ),
            ),
          ],
          views: const [
            Tab(
              child: DadosCuidador(),
            ),
            Tab(child: PacientesCuidador()),
          ],
        ),
      ),
    );
  }
}

class PacientesCuidador extends StatelessWidget {
  const PacientesCuidador({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CuidadorProvider cuidadorProvider = context.watch<CuidadorProvider>();
    return Builder(builder: (context) {
      cuidadorProvider.todosPacientes();
      return ListView.builder(
        itemCount: cuidadorProvider.pacientes.length,
        itemBuilder: (context, index) {
          return ItemContainer(
            title: cuidadorProvider.pacientes[index].nome,
          );
        },
      );
    });
  }
}

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
  final TextEditingController _complementoRuaController =
      TextEditingController();
  final TextEditingController _cidadeController = TextEditingController();
  final TextEditingController _estadoController = TextEditingController();

  @override
  void initState() {
    _cpfController.addListener(() {
      // Listener para atualizar o CPF do responsável
      context.read<CuidadorProvider>().cuidador.cpf = _cpfController.text;
    });
    _nomeController.addListener(() {
      // Listener para atualizar o nome do responsável
      context.read<CuidadorProvider>().cuidador.nome = _nomeController.text;
    });
    _nascimentoController.addListener(() {
      // Listener para atualizar a data de nascimento do responsável
      context.read<CuidadorProvider>().cuidador.nascimento =
          _nascimentoController.text;
    });
    _emailController.addListener(() {
      // Listener para atualizar o email do responsável
      context.read<CuidadorProvider>().cuidador.email = _emailController.text;
    });
    _telefoneController.addListener(() {
      // Listener para atualizar o telefone do responsável
      context.read<CuidadorProvider>().cuidador.telefone =
          _telefoneController.text;
    });

    _ruaController.addListener(() {
      // Listener para atualizar a rua do responsável
      context.read<CuidadorProvider>().cuidador.rua = _ruaController.text;
    });
    _bairroController.addListener(() {
      // Listener para atualizar o bairro do responsável
      context.read<CuidadorProvider>().cuidador.bairro = _bairroController.text;
    });
    _numeroRuaController.addListener(() {
      // Listener para atualizar o número da rua do responsável
      context.read<CuidadorProvider>().cuidador.numeroRua =
          _numeroRuaController.text;
    });
    _complementoRuaController.addListener(() {
      // Listener para atualizar o complemento da rua do responsável
      context.read<CuidadorProvider>().cuidador.complementoRua =
          _complementoRuaController.text;
    });
    _cidadeController.addListener(() {
      // Listener para atualizar a cidade do responsável
      context.read<CuidadorProvider>().cuidador.cidade = _cidadeController.text;
    });
    _estadoController.addListener(() {
      // Listener para atualizar o estado do responsável
      context.read<CuidadorProvider>().cuidador.estado = _estadoController.text;
    });
    _cepController.addListener(() {
      // Listener para atualizar o CEP do responsável
      context.read<CuidadorProvider>().cuidador.cep = _cepController.text;
      // Listener para atualizar os campos de endereço
      if (_cepController.text.length == 9) {
        CepAPI.getCep(_cepController.text).then((value) {
          if (value['cep'] != null) {
            _ruaController.text = value['logradouro'];
            _bairroController.text = value['bairro'];
            _cidadeController.text = value['localidade'];
            _estadoController.text = value['uf'];
            context.read<CuidadorProvider>().cuidador.rua = value['logradouro'];
            context.read<CuidadorProvider>().cuidador.bairro = value['bairro'];
            context.read<CuidadorProvider>().cuidador.cidade =
                value['localidade'];
            context.read<CuidadorProvider>().cuidador.estado = value['uf'];

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
    final CuidadorProvider cuidadorProvider = context.watch<CuidadorProvider>();
    _cpfController.text = cuidadorProvider.cuidador.cpf;
    _nomeController.text = cuidadorProvider.cuidador.nome;
    _nascimentoController.text = cuidadorProvider.cuidador.nascimento;
    _emailController.text = cuidadorProvider.cuidador.email;
    _telefoneController.text = cuidadorProvider.cuidador.telefone;
    _cepController.text = cuidadorProvider.cuidador.cep;
    _ruaController.text = cuidadorProvider.cuidador.rua;
    _bairroController.text = cuidadorProvider.cuidador.bairro;
    _numeroRuaController.text = cuidadorProvider.cuidador.numeroRua;
    _complementoRuaController.text = cuidadorProvider.cuidador.complementoRua;
    _cidadeController.text = cuidadorProvider.cuidador.cidade;
    _estadoController.text = cuidadorProvider.cuidador.estado;

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
                  value: cuidadorProvider.cuidador.ativo,
                  onChanged: (value) {
                    cuidadorProvider.cuidador.ativo = value;
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
