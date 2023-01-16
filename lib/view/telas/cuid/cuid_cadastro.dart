// ignore_for_file: unused_import

import 'package:cangurugestor/model/cuidador.dart';
import 'package:cangurugestor/model/paciente.dart';
import 'package:cangurugestor/firebaseUtils/fire_cuidador.dart';
import 'package:cangurugestor/firebaseUtils/fire_paciente.dart';
import 'package:cangurugestor/firebaseUtils/fire_responsavel.dart';
import 'package:cangurugestor/view/componentes/adicionar_botao_tarefa.dart';
import 'package:cangurugestor/view/componentes/agrupador_cadastro.dart';
import 'package:cangurugestor/view/componentes/form_cadastro.dart';
import 'package:cangurugestor/view/componentes/form_cadastro_data.dart';
import 'package:cangurugestor/view/componentes/adicionar_botao_rpc.dart';
import 'package:cangurugestor/view/componentes/header_cadastro.dart';
import 'package:cangurugestor/view/componentes/styles.dart';
import 'package:cangurugestor/view/telas/paci/paci_cadastro.dart';
import 'package:cangurugestor/utils/cep_api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cangurugestor/global.dart' as global;
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class CadastroCuidador extends StatefulWidget {
  const CadastroCuidador({
    Key? key,
  }) : super(key: key);

  @override
  State<CadastroCuidador> createState() => _CadastroCuidadorState();
}

class _CadastroCuidadorState extends State<CadastroCuidador> {
  var cpfController = TextEditingController();
  var nomeController = TextEditingController();
  var nascimentoController = TextEditingController();
  var emailController = TextEditingController();
  var telefoneController = TextEditingController();
  var senhaController = TextEditingController();
  var cepController = TextEditingController();
  var ruaController = TextEditingController();
  var bairroController = TextEditingController();
  var numeroRuaController = TextEditingController();
  var complementoRuaController = TextEditingController();
  var cidadeController = TextEditingController();
  var estadoController = TextEditingController();
  final _formKeyDadosPessoais = GlobalKey<FormState>();
  final _formKeyEndereco = GlobalKey<FormState>();
  bool ativo = true;
  List<Widget> pacientesWidget = [];
  final FirestoreResponsavel firestoreResponsavel = FirestoreResponsavel();
  final FirestoreCuidador firestoreCuidador = FirestoreCuidador();

  @override
  void initState() {
    cepController.addListener(() {
      // Listener para atualizar os campos de endereço
      if (cepController.text.length == 9) {
        CepAPI.getCep(cepController.text).then((value) {
          if (value['cep'] != null) {
            ruaController.text = value['logradouro'];
            bairroController.text = value['bairro'];
            cidadeController.text = value['localidade'];
            estadoController.text = value['uf'];
            return;
          } else {
            ruaController.text = '';
            bairroController.text = '';
            cidadeController.text = '';
            estadoController.text = '';
          }
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    cpfController.dispose();
    nomeController.dispose();
    nascimentoController.dispose();
    emailController.dispose();
    telefoneController.dispose();
    senhaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          child: Center(
            child: ListView(
              children: [
                Center(
                  child: Column(
                    children: [
                      HeaderCadastro(
                        texto: 'Cuidador',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: corPad1,
        child: SizedBox(
          height: 50,
          child: Center(
            child: IconButton(
              onPressed: () {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              icon: const Icon(
                Icons.save,
                size: 30,
                color: corPad3,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget configuracoesGroup() {
    return AgrupadorCadastro(
      leading: Container(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.settings,
          size: 40,
          color: Color.fromARGB(255, 10, 48, 88),
        ),
      ),
      titulo: 'Configurações do App',
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Ativo',
                style: TextStyle(color: corPad1, fontSize: 15),
              ),
              Switch(
                value: ativo,
                onChanged: (value) {},
              ),
            ],
          ),
        ),
        FormCadastro(
          enabled: true,
          controller: senhaController,
          labelText: 'Senha',
          textInputType: TextInputType.number,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 20),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Text(
                'ID:  ',
                style: const TextStyle(color: corPad1, fontSize: 15),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget enderecoGroup() {
    return Form(
      key: _formKeyEndereco,
      child: AgrupadorCadastro(
          leading: Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.location_on,
              size: 40,
              color: Color.fromARGB(255, 10, 48, 88),
            ),
          ),
          titulo: 'Endereço',
          children: [
            FormCadastro(
              enabled: true,
              controller: cepController,
              labelText: 'CEP',
              hintText: '000000-000',
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                MaskTextInputFormatter(
                    mask: "#####-###", filter: {"#": RegExp(r'[0-9]')})
              ],
              textInputType: TextInputType.text,
            ),
            FormCadastro(
              enabled: true,
              controller: ruaController,
              labelText: 'Endereço',
              textInputType: TextInputType.text,
            ),
            FormCadastro(
              enabled: true,
              controller: complementoRuaController,
              labelText: 'Complemento',
              textInputType: TextInputType.text,
            ),
            FormCadastro(
              enabled: true,
              controller: bairroController,
              labelText: 'Bairro',
              textInputType: TextInputType.text,
            ),
            FormCadastro(
              enabled: true,
              controller: cidadeController,
              labelText: 'Cidade',
              textInputType: TextInputType.text,
            ),
            FormCadastro(
              enabled: true,
              controller: estadoController,
              labelText: 'Estado',
              textInputType: TextInputType.text,
            ),
          ]),
    );
  }

  Widget dadosPessoaisGroup() {
    return Form(
      key: _formKeyDadosPessoais,
      child: AgrupadorCadastro(
        leading: Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.person,
            size: 40,
            color: Color.fromARGB(255, 10, 48, 88),
          ),
        ),
        titulo: 'Dados pessoais',
        children: [
          FormCadastro(
            enabled: true,
            controller: cpfController,
            labelText: 'CPF',
            inputFormatters: [
              MaskTextInputFormatter(
                  mask: "###.###.###-##", filter: {"#": RegExp(r'[0-9]')})
            ],
            textInputType: TextInputType.phone,
          ),
          FormCadastro(
            enabled: true,
            controller: nomeController,
            labelText: 'Nome',
            textInputType: TextInputType.text,
          ),
          FormCadastroData(
            enabled: true,
            dataPrimeira: DateTime(DateTime.now().year - 100),
            dataInicial: DateTime(DateTime.now().year - 10),
            dataUltima: DateTime(DateTime.now().year),
            controller: nascimentoController,
            labelText: 'Data de nascimento',
            textInputType: TextInputType.none,
          ),
          FormCadastro(
            enabled: true,
            controller: emailController,
            labelText: 'e-mail',
            textInputType: TextInputType.text,
          ),
          FormCadastro(
            enabled: true,
            controller: telefoneController,
            labelText: 'Celular',
            textInputType: TextInputType.number,
            inputFormatters: [
              MaskTextInputFormatter(
                  mask: "## #####-####", filter: {"#": RegExp(r'[0-9]')})
            ],
          ),
        ],
      ),
    );
  }
}
