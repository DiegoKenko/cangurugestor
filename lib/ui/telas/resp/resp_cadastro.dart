import 'package:cangurugestor/classes/cuidador.dart';
import 'package:cangurugestor/classes/paciente.dart';
import 'package:cangurugestor/classes/responsavel.dart';
import 'package:cangurugestor/firebaseUtils/firestore_funcoes.dart';
import 'package:cangurugestor/global.dart';
import 'package:cangurugestor/ui/componentes/adicionar_botao_rpc.dart';
import 'package:cangurugestor/ui/componentes/agrupador_cadastro.dart';
import 'package:cangurugestor/ui/componentes/app_bar.dart';
import 'package:cangurugestor/ui/componentes/form_cadastro.dart';
import 'package:cangurugestor/ui/componentes/form_cadastro_data.dart';
import 'package:cangurugestor/ui/componentes/header_cadastro.dart';
import 'package:cangurugestor/ui/componentes/item_cuidador.dart';
import 'package:cangurugestor/ui/componentes/item_paciente.dart';
import 'package:cangurugestor/ui/componentes/styles.dart';
import 'package:cangurugestor/ui/telas/cuid/cuid_cadastro.dart';
import 'package:cangurugestor/ui/telas/paci/paci_cadastro.dart';
import 'package:cangurugestor/utils/cep_api.dart';
import 'package:flutter/material.dart';
import 'package:cangurugestor/global.dart' as global;
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class CadastroResponsavel extends StatefulWidget {
  Responsavel? responsavel = Responsavel();
  final int opcao;
  final int privilegio;
  bool edit = false;
  bool delete = false;
  CadastroResponsavel({
    Key? key,
    this.responsavel,
    required this.opcao,
    this.privilegio = global.privilegioCuidador,
  }) : super(key: key) {
    // Atualiza globais
    edit = privilegio == global.privilegioGestor;
    delete = privilegio == global.privilegioGestor;
    responsavel?.idGestor = global.idGestorGlobal;
    if (opcao == opcaoInclusao) {
      responsavel = Responsavel();
    } else {
      global.idResponsavelGlobal = responsavel!.id ?? '';
    }
  }

  @override
  State<CadastroResponsavel> createState() => _CadastroResponsavelState();
}

class _CadastroResponsavelState extends State<CadastroResponsavel> {
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
  bool ativo = false;
  List<Widget> pacientesWidget = [];
  List<Widget> cuidadoresWidget = [];

  @override
  void initState() {
    // Controladores para editar ou não os campos do formulário
    cpfController = TextEditingController(text: widget.responsavel?.cpf);
    nomeController = TextEditingController(text: widget.responsavel?.nome);
    nascimentoController =
        TextEditingController(text: widget.responsavel?.nascimento.toString());
    emailController = TextEditingController(text: widget.responsavel?.email);
    telefoneController =
        TextEditingController(text: widget.responsavel?.telefone);
    senhaController = TextEditingController(text: widget.responsavel?.senha);
    cepController = TextEditingController(text: widget.responsavel?.cep);
    cepController.addListener(() {
      // Listener para atualizar os campos de endereço
      if (cepController.text.length == 9) {
        CepAPI.getCep(cepController.text).then((value) {
          if (value['erro'] == 'true') {
            ruaController.text = '';
            bairroController.text = '';
            cidadeController.text = '';
            estadoController.text = '';
            return;
          }
          ruaController.text = value['logradouro'];
          bairroController.text = value['bairro'];
          cidadeController.text = value['localidade'];
          estadoController.text = value['uf'];
        });
      }
    });

    ruaController = TextEditingController(text: widget.responsavel?.rua);
    bairroController = TextEditingController(text: widget.responsavel?.bairro);
    numeroRuaController =
        TextEditingController(text: widget.responsavel?.numeroRua);
    complementoRuaController =
        TextEditingController(text: widget.responsavel?.complementoRua);
    cidadeController = TextEditingController(text: widget.responsavel?.cidade);
    estadoController = TextEditingController(text: widget.responsavel?.estado);

    // Ativo/Inativo
    ativo = widget.responsavel?.ativo ?? false;

    // Reponsável atual global
    global.idResponsavelGlobal = widget.responsavel?.id ?? '';

    //
    resetarBotao();
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
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (widget.responsavel!.id!.isEmpty) {
              Navigator.pop(context);
            } else {
              Navigator.pop(context, widget.responsavel);
            }
          },
        ),
        actions: [
          widget.edit
              ? IconButton(
                  onPressed: () {
                    if (_formKeyDadosPessoais.currentState!.validate() &&
                        _formKeyEndereco.currentState!.validate()) {
                      FocusManager.instance.primaryFocus?.unfocus();
                      addResponsavel();
                    }
                  },
                  icon: const Icon(
                    Icons.save,
                    size: 30,
                  ),
                )
              : Container(),
          widget.delete
              ? IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: (() {
                    FocusManager.instance.primaryFocus?.unfocus();
                    excluirResponsavel();
                    Navigator.pop(context);
                  }),
                )
              : Container(),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 30),
          child: Center(
            child: ListView(
              children: [
                Center(
                  child: Column(
                    children: [
                      widget.responsavel != null
                          ? HeaderCadastro(
                              texto:
                                  '${widget.responsavel!.nome} ${widget.responsavel!.sobrenome}')
                          : HeaderCadastro(),
                    ],
                  ),
                ),
                global.idResponsavelGlobal.isNotEmpty
                    ? pacienteGroup()
                    : Container(),
                global.idResponsavelGlobal.isNotEmpty
                    ? cuidadorGroup()
                    : Container(),
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
        child: Container(
          height: 50,
        ),
      ),
    );
  }

  Widget botaoAdicionarPaciente() {
    return widget.privilegio == global.privilegioGestor
        ? BotaoCadastro(
            onPressed: () {
              final result = Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return CadastroPaciente(
                    privilegio: widget.privilegio,
                    opcao: global.opcaoInclusao,
                  );
                }),
              );
              result.then((value) {
                if (value != null) {
                  setState(() {
                    pacientesWidget.insert(
                      0,
                      ItemPaciente(
                          privilegio: widget.privilegio, paciente: value),
                    );
                  });
                }
              });
            },
          )
        : Container();
  }

  Widget botaoAdicionarCuidador() {
    return widget.privilegio == global.privilegioGestor
        ? BotaoCadastro(onPressed: () {
            final result = Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CadastroCuidador(
                  privilegio: widget.privilegio,
                  opcao: global.opcaoInclusao,
                ),
              ),
            );
            result.then((value) {
              if (value != null) {
                setState(() {
                  cuidadoresWidget.insert(
                    0,
                    ItemCuidador(
                      cuidador: value,
                      privilegio: widget.privilegio,
                    ),
                  );
                });
              }
            });
          })
        : Container();
  }

  AgrupadorCadastro configuracoesGroup() {
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
              value: ativo,
              onChanged: (value) {
                setState(() {
                  ativo = value;
                  widget.responsavel?.ativo = ativo;
                });
              },
            ),
          ],
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
                'ID:  ${widget.responsavel!.id}',
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
          initiallyExpanded: false,
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
                MaskTextInputFormatter(
                    mask: "#####-###", filter: {"#": RegExp(r'[0-9]')})
              ],
              textInputType: TextInputType.text,
            ),
            FormCadastro(
              obrigatorio: true,
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
              obrigatorio: true,
              enabled: true,
              controller: bairroController,
              labelText: 'Bairro',
              textInputType: TextInputType.text,
            ),
            FormCadastro(
              obrigatorio: true,
              enabled: true,
              controller: cidadeController,
              labelText: 'Cidade',
              textInputType: TextInputType.text,
            ),
            FormCadastro(
              obrigatorio: true,
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
        initiallyExpanded: false,
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
            obrigatorio: true,
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
            obrigatorio: true,
            enabled: true,
            controller: nomeController,
            labelText: 'Nome',
            textInputType: TextInputType.text,
          ),
          FormCadastroData(
            obrigatorio: true,
            enabled: true,
            dataPrimeira: DateTime(DateTime.now().year - 100),
            dataInicial: DateTime(DateTime.now().year - 10),
            dataUltima: DateTime(DateTime.now().year),
            controller: nascimentoController,
            labelText: 'Data de nascimento',
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

  FutureBuilder<List<Cuidador>> cuidadorGroup() {
    return FutureBuilder(
        future: MeuFirestore().todosCuidadores(widget.responsavel!.id!),
        builder:
            (BuildContext buildcontext, AsyncSnapshot<List<Cuidador>> snap) {
          if (snap.hasData) {
            if (snap.data!.isNotEmpty) {
              resetarBotao();
              for (var element in snap.data!) {
                cuidadoresWidget.insert(
                  0,
                  ItemCuidador(
                    cuidador: element,
                    privilegio: widget.privilegio,
                  ),
                );
              }
            }
          }
          // Retorno
          return AgrupadorCadastro(
            leading: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person_pin,
                size: 40,
                color: Color.fromARGB(255, 10, 48, 88),
              ),
            ),
            titulo: 'Cuidadores',
            children: cuidadoresWidget,
          );
        });
  }

  FutureBuilder<List<Paciente>> pacienteGroup() {
    return FutureBuilder(
      future: MeuFirestore().todosPacientes(widget.responsavel!.id!),
      builder: (BuildContext context, AsyncSnapshot<List<Paciente>> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.isNotEmpty) {
            resetarBotao();
            for (var element in snapshot.data!) {
              pacientesWidget.insert(
                0,
                ItemPaciente(privilegio: widget.privilegio, paciente: element),
              );
            }
          }
        }
        return AgrupadorCadastro(
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
          titulo: 'Pacientes',
          children: pacientesWidget,
        );
      },
    );
  }

  void resetarBotao() {
    pacientesWidget = [];
    pacientesWidget.insert(0, botaoAdicionarPaciente());
    cuidadoresWidget = [];
    cuidadoresWidget.insert(0, botaoAdicionarCuidador());
  }

  Future<void> addResponsavel() async {
    widget.responsavel!.cpf = cpfController.text;
    widget.responsavel!.nome = nomeController.text;
    widget.responsavel!.idGestor = global.idGestorGlobal;
    widget.responsavel!.email = emailController.text;
    widget.responsavel!.telefone = telefoneController.text;
    widget.responsavel!.senha = senhaController.text;
    widget.responsavel!.rua = ruaController.text;
    widget.responsavel!.complementoRua = complementoRuaController.text;
    widget.responsavel!.numeroRua = numeroRuaController.text;
    widget.responsavel!.bairro = bairroController.text;
    widget.responsavel!.cep = cepController.text;
    widget.responsavel!.cidade = cidadeController.text;
    widget.responsavel!.estado = estadoController.text;
    widget.responsavel!.nascimento = nascimentoController.text;
    widget.responsavel!.ativo = ativo;

    if (widget.opcao == global.opcaoInclusao &&
        widget.responsavel!.nome.isNotEmpty &&
        widget.responsavel!.cpf.isNotEmpty &&
        widget.responsavel!.id == '') {
      var resp = await MeuFirestore.incluirResponsavel(widget.responsavel!);
      setState(() {
        widget.responsavel = resp;
        idResponsavelGlobal = resp.id!;
      });
    } else if (widget.responsavel!.id!.isNotEmpty) {
      MeuFirestore.atualizarResponavel(widget.responsavel!);
    }
  }

  void excluirResponsavel() {
    MeuFirestore.excluirResponsavel(widget.responsavel!.id!);
  }
}
