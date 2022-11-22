// ignore_for_file: unused_import

import 'package:cangurugestor/classes/cuidador.dart';
import 'package:cangurugestor/classes/paciente.dart';
import 'package:cangurugestor/firebaseUtils/fire_cuidador.dart';
import 'package:cangurugestor/firebaseUtils/fire_paciente.dart';
import 'package:cangurugestor/firebaseUtils/fire_responsavel.dart';
import 'package:cangurugestor/ui/componentes/adicionar_botao_tarefa.dart';
import 'package:cangurugestor/ui/componentes/agrupador_cadastro.dart';
import 'package:cangurugestor/ui/componentes/app_bar.dart';
import 'package:cangurugestor/ui/componentes/form_cadastro.dart';
import 'package:cangurugestor/ui/componentes/form_cadastro_data.dart';
import 'package:cangurugestor/ui/componentes/adicionar_botao_rpc.dart';
import 'package:cangurugestor/ui/componentes/header_cadastro.dart';
import 'package:cangurugestor/ui/componentes/item_paciente.dart';
import 'package:cangurugestor/ui/componentes/styles.dart';
import 'package:cangurugestor/ui/telas/paci/paci_cadastro.dart';
import 'package:cangurugestor/utils/cep_api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cangurugestor/global.dart' as global;
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class CadastroCuidador extends StatefulWidget {
  Cuidador? cuidador = Cuidador();
  final int opcao;
  final int privilegio;
  bool edit = false;
  bool delete = false;
  CadastroCuidador({
    Key? key,
    this.cuidador,
    required this.opcao,
    required this.privilegio,
  }) : super(key: key) {
    edit = privilegio == global.privilegioGestor;
    delete = privilegio == global.privilegioGestor;
    if (opcao == global.opcaoAlteracao) {
      global.idCuidadorGlobal = cuidador!.id;
    }
    if (opcao == global.opcaoInclusao) {
      cuidador = Cuidador();
    }
    cuidador!.pacientes = [];
  }

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
    ativo = widget.cuidador!.ativo;
    cpfController = TextEditingController(text: widget.cuidador?.cpf);
    nomeController = TextEditingController(text: widget.cuidador?.nome);
    nascimentoController =
        TextEditingController(text: widget.cuidador?.nascimento.toString());
    emailController = TextEditingController(text: widget.cuidador?.email);
    telefoneController = TextEditingController(text: widget.cuidador?.telefone);
    senhaController = TextEditingController(text: widget.cuidador?.senha);
    cepController = TextEditingController(text: widget.cuidador?.cep);
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
    ruaController = TextEditingController(text: widget.cuidador?.rua);
    bairroController = TextEditingController(text: widget.cuidador?.bairro);
    numeroRuaController =
        TextEditingController(text: widget.cuidador?.numeroRua);
    complementoRuaController =
        TextEditingController(text: widget.cuidador?.complementoRua);
    cidadeController = TextEditingController(text: widget.cuidador?.cidade);
    estadoController = TextEditingController(text: widget.cuidador?.estado);
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
      appBar: AppBarCan(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: widget.cuidador!.id.isEmpty ? Colors.red : Colors.white,
          ),
          onPressed: () {
            if (widget.cuidador!.id.isEmpty) {
              Navigator.pop(context);
            } else {
              Navigator.pop(context, widget.cuidador);
            }
          },
        ),
        actions: [
          widget.delete
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: (() {
                      FocusManager.instance.primaryFocus?.unfocus();
                      excluirCuidador();
                      Navigator.pop(context);
                    }),
                  ),
                )
              : Container(),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          child: Center(
            child: ListView(
              children: [
                Center(
                  child: Column(
                    children: [
                      widget.cuidador != null
                          ? HeaderCadastro(
                              texto:
                                  '${widget.cuidador!.nome} ${widget.cuidador!.sobrenome}')
                          : HeaderCadastro(),
                    ],
                  ),
                ),
                widget.cuidador!.id.isNotEmpty ? pacienteGroup() : Container(),
                dadosPessoaisGroup(),
                enderecoGroup(),
                configuracoesGroup(),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: corPad1,
        child: SizedBox(
          height: 50,
          child: widget.edit
              ? Center(
                  child: IconButton(
                    onPressed: () {
                      FocusManager.instance.primaryFocus?.unfocus();
                      addCuidador();
                    },
                    icon: const Icon(
                      Icons.save,
                      size: 30,
                      color: corPad3,
                    ),
                  ),
                )
              : Container(),
        ),
      ),
    );
  }

  configuracoesGroup() {
    return AgrupadorCadastro(
      initiallyExpanded: false,
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
                onChanged: (value) {
                  setState(() {
                    ativo = value;
                    widget.cuidador?.ativo = ativo;
                  });
                },
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
                'ID:  ${widget.cuidador!.id}',
                style: const TextStyle(color: corPad1, fontSize: 15),
              ),
            ),
          ),
        ),
      ],
    );
  }

  enderecoGroup() {
    return Form(
      key: _formKeyEndereco,
      child: AgrupadorCadastro(
          initiallyExpanded: true,
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

  dadosPessoaisGroup() {
    return Form(
      key: _formKeyDadosPessoais,
      child: AgrupadorCadastro(
        initiallyExpanded: true,
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

  FutureBuilder<List<Paciente>> pacienteGroup() {
    return FutureBuilder(
        future: firestoreCuidador.todosPacientesCuidador(
            global.idResponsavelGlobal, widget.cuidador!.id),
        builder: (context, AsyncSnapshot<List<Paciente>> builder) {
          if (builder.hasData) {
            List<Paciente> pacientes = builder.data as List<Paciente>;
            pacientesWidget = [];
            for (var paciente in pacientes) {
              pacientesWidget.add(
                ItemPaciente(
                  privilegio: widget.privilegio,
                  paciente: paciente,
                ),
              );
            }
            pacientesWidget.add(botaoAdicionarPaciente(context));
          }
          return AgrupadorCadastro(
              initiallyExpanded: true,
              leading: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.personal_injury,
                  size: 40,
                  color: Color.fromARGB(255, 10, 48, 88),
                ),
              ),
              titulo: 'Responsável por:',
              children: pacientesWidget);
        });
  }

  Widget botaoAdicionarPaciente(BuildContext context) {
    return BotaoCadastro(
      onPressed: () {
        Scaffold.of(context).showBottomSheet<void>(
          (BuildContext context) {
            return FutureBuilder(
              future: firestoreResponsavel
                  .todosPacientesResponsavel(global.idResponsavelGlobal),
              builder: (context, AsyncSnapshot<List<Paciente>> snapshot) {
                if (snapshot.hasData) {
                  List<Paciente>? pacientes = snapshot.data;

                  if (pacientes!.isNotEmpty) {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height * 0.7,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(bottom: 30),
                            height: 20,
                            color: corPad1.withOpacity(0.8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  color: corPad1.withOpacity(0.2),
                                )
                              ],
                            ),
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height * 0.6,
                            color: corPad3,
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: pacientes.length,
                              itemBuilder: (context, index) {
                                return listTilePaciente(
                                  pacientes[index],
                                  widget.cuidador!,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return Container();
                }
                return Container();
              },
            );
          },
        );
      },
    );
  }

  Future<void> addCuidador() async {
    widget.cuidador!.nome = nomeController.text;
    widget.cuidador!.cpf = cpfController.text;
    widget.cuidador!.email = emailController.text;
    widget.cuidador!.telefone = telefoneController.text;
    widget.cuidador!.nascimento = nascimentoController.text;
    widget.cuidador!.cep = cepController.text;
    widget.cuidador!.rua = ruaController.text;
    widget.cuidador!.complementoRua = complementoRuaController.text;
    widget.cuidador!.bairro = bairroController.text;
    widget.cuidador!.cidade = cidadeController.text;
    widget.cuidador!.estado = estadoController.text;
    widget.cuidador!.senha = senhaController.text;
    widget.cuidador!.idResponsavel = global.idResponsavelGlobal;

    if (widget.opcao == global.opcaoInclusao &&
        widget.cuidador!.nome.isNotEmpty &&
        widget.cuidador!.cpf.isNotEmpty &&
        widget.cuidador!.id == '') {
      var cuid = await firestoreCuidador.incluirCuidador(widget.cuidador!);
      setState(() {
        widget.cuidador = cuid;
      });
    } else if (widget.cuidador!.id.isNotEmpty) {
      firestoreCuidador.atualizarCuidador(widget.cuidador!);
    }
  }

  void excluirCuidador() {
    firestoreCuidador.excluirCuidador(widget.cuidador!.id);
  }

  listTilePaciente(Paciente paciente, Cuidador cuidador) {
    final bool exists = cuidador.pacientes!.firstWhere(
            (element) => element.id == paciente.id,
            orElse: () => Paciente()) !=
        Paciente();
    return Container(
      decoration: kBoxDecorationSetPaciente,
      margin: const EdgeInsets.only(left: 30, right: 30, top: 10),
      child: ListTile(
        onTap: () {
          setState(() {
            if (exists) {
              firestoreCuidador.incluirPacienteCuidador(
                  paciente.id, widget.cuidador!.id);
            } else {
              firestoreCuidador.excluirPacienteCuidador(
                  paciente.id, widget.cuidador!.id);
            }
          });
          Navigator.pop(context);
        },
        title: Text(
          paciente.nome,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        subtitle: Text(paciente.cpf),
        trailing: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
