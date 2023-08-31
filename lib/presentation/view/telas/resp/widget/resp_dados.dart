import 'package:cangurugestor/const/global.dart';
import 'package:cangurugestor/presentation/controller/responsavel_controller.dart';
import 'package:cangurugestor/presentation/state/responsavel_state.dart';
import 'package:cangurugestor/presentation/utils/cep_api.dart';
import 'package:cangurugestor/presentation/view/componentes/form_cadastro.dart';
import 'package:cangurugestor/presentation/view/componentes/form_cadastro_data.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

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
                    ),
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
                    ),
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
                    ),
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
