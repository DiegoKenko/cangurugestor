import 'package:cangurugestor/const/global.dart';
import 'package:cangurugestor/domain/entity/paciente_entity.dart';
import 'package:cangurugestor/domain/entity/responsavel_entity.dart';
import 'package:cangurugestor/presentation/state/responsavel_state.dart';
import 'package:cangurugestor/presentation/view/componentes/adicionar_botao_rpc.dart';
import 'package:cangurugestor/presentation/view/componentes/animated_page_transition.dart';
import 'package:cangurugestor/presentation/view/componentes/dialog_confirmacao_exclusao.dart';
import 'package:cangurugestor/presentation/view/componentes/form_cadastro.dart';
import 'package:cangurugestor/presentation/view/componentes/form_cadastro_data.dart';
import 'package:cangurugestor/presentation/view/componentes/item_container.dart';
import 'package:cangurugestor/presentation/view/componentes/styles.dart';
import 'package:cangurugestor/presentation/utils/cep_api.dart';
import 'package:cangurugestor/presentation/view/componentes/tab.dart';
import 'package:cangurugestor/presentation/view/telas/paci/paci_cadastro.dart';
import 'package:cangurugestor/presentation/controller/auth_controller.dart';
import 'package:cangurugestor/presentation/controller/paciente_controller.dart';
import 'package:cangurugestor/presentation/controller/responsavel_controller.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

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
    _tabController.addListener(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return DialogConfirmacaoExclusao(
                    onConfirm: () {},
                  );
                },
              );
            },
          ),
        ],
        title: Column(
          children: [
            Text(
              '',
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
          views: const [
            Tab(
              child: DadosResponsavel(),
            ),
            Tab(child: PacientesResponsavel()),
            Tab(
              child: SingleChildScrollView(
                child: Column(
                  children: [
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
    return ValueListenableBuilder(
      valueListenable: getIt<ResponsavelController>(),
      builder: (context, state, _) {
        ResponsavelEntity responsavel = ResponsavelEntity();
        if (state is ResponsavelSuccessState) {
          responsavel = state.responsavel;
        }
        return Column(
          children: [
            responsavel.pacientes.isEmpty
                ? const Expanded(
                    child: Center(
                      child: Text('nenhum paciente cadastrado'),
                    ),
                  )
                : Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: responsavel.pacientes.length,
                      itemBuilder: (context, index) {
                        PacienteEntity paciente = responsavel.pacientes[index];
                        return ItemContainer(
                          leading: const CircleAvatar(
                            backgroundImage: AssetImage('assets/avatar.png'),
                          ),
                          onTap: () {
                            Navigator.of(context).push(
                              AnimatedPageTransition(
                                page: const CadastroPaciente(),
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
                        page: const CadastroPaciente(),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
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
  final TextEditingController _cidadeController = TextEditingController();
  final TextEditingController _estadoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _cpfController.addListener(() {});
    _nomeController.addListener(() {});
    _nascimentoController.addListener(() {});
    _emailController.addListener(() {});
    _telefoneController.addListener(() {});
    _numeroRuaController.addListener(() {});
    _cepController.addListener(() async {});
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
      child: ValueListenableBuilder(
        valueListenable: getIt<ResponsavelController>(),
        builder: (context, state, _) {
          if (state is ResponsavelSuccessState) {
            _cpfController.text = state.responsavel.cpf;
            _nomeController.text = state.responsavel.nome;
            _nascimentoController.text = state.responsavel.nascimento;
            _emailController.text = state.responsavel.email;
            _telefoneController.text = state.responsavel.telefone;
            _cepController.text = state.responsavel.cep;
          }
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
