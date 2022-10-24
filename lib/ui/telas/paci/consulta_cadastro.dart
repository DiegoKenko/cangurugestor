import 'package:cangurugestor/classes/consulta.dart';
import 'package:cangurugestor/firebaseUtils/firestore_funcoes.dart';
import 'package:cangurugestor/ui/componentes/agrupador_cadastro.dart';
import 'package:cangurugestor/ui/componentes/app_bar.dart';
import 'package:cangurugestor/ui/componentes/form_cadastro.dart';
import 'package:cangurugestor/ui/componentes/form_cadastro_data.dart';
import 'package:cangurugestor/ui/componentes/form_cadastro_hora.dart';
import 'package:cangurugestor/ui/componentes/styles.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import 'package:cangurugestor/global.dart' as global;

class ConsultaCadastro extends StatefulWidget {
  Consulta? consulta;
  final int opcao;
  final int privilegio;
  bool edit;
  bool delete;
  ConsultaCadastro(
      {Key? key,
      this.consulta,
      this.edit = false,
      this.delete = false,
      required this.opcao,
      required this.privilegio})
      : super(key: key) {
    edit = privilegio == global.privilegioGestor;
    delete = privilegio == global.privilegioGestor;
  }

  @override
  State<ConsultaCadastro> createState() => _ConsultaCadastroState();
}

class _ConsultaCadastroState extends State<ConsultaCadastro> {
  TextEditingController nomeController = TextEditingController();
  TextEditingController dataController = TextEditingController();
  TextEditingController horaController = TextEditingController();
  TextEditingController medicoController = TextEditingController();
  TextEditingController cuidadorController = TextEditingController();
  TextEditingController cepController = TextEditingController();
  TextEditingController ruaController = TextEditingController();
  TextEditingController bairroController = TextEditingController();
  TextEditingController numeroRuaController = TextEditingController();
  TextEditingController complementoRuaController = TextEditingController();
  TextEditingController cidadeController = TextEditingController();
  TextEditingController estadoController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    widget.consulta ??= Consulta();
    dataController =
        TextEditingController(text: widget.consulta?.data.toString());
    horaController = TextEditingController(text: widget.consulta?.hora);
    nomeController = TextEditingController(text: widget.consulta?.nome);
    medicoController = TextEditingController(text: widget.consulta?.medico);
    cepController = TextEditingController(text: widget.consulta?.local?.cep);
    ruaController = TextEditingController(text: widget.consulta?.local?.rua);
    bairroController =
        TextEditingController(text: widget.consulta?.local?.bairro);
    numeroRuaController =
        TextEditingController(text: widget.consulta?.local?.numeroRua);
    complementoRuaController =
        TextEditingController(text: widget.consulta?.local?.complementoRua);
    cidadeController =
        TextEditingController(text: widget.consulta?.local?.cidade);
    estadoController =
        TextEditingController(text: widget.consulta?.local?.estado);

    super.initState();
  }

  @override
  void dispose() {
    dataController.dispose();
    nomeController.dispose();
    horaController.dispose();
    medicoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCan(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, widget.consulta);
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
                      excluirConsulta();
                      Navigator.pop(context);
                    }),
                  ),
                )
              : Container(),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 10,
            top: 30,
            bottom: 30,
            right: 10,
          ),
          child: Form(
            key: _formKey,
            child: Center(
              child: ListView(
                children: [
                  AgrupadorCadastro(
                    leading: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.edit_calendar,
                        size: 40,
                        color: Color.fromARGB(255, 10, 48, 88),
                      ),
                    ),
                    titulo: 'Consulta',
                    children: [
                      FormCadastro(
                        enabled: widget.edit,
                        controller: nomeController,
                        labelText: 'Descrição',
                        textInputType: TextInputType.number,
                      ),
                      FormCadastroData(
                          controller: dataController,
                          labelText: 'Data',
                          dataPrimeira: DateTime.now(),
                          dataInicial: DateTime.now(),
                          dataUltima: DateTime(DateTime.now().year + 10),
                          enabled: widget.edit,
                          textInputType: TextInputType.none),
                      FormCadastroHora(
                          controller: horaController,
                          labelText: 'Hora',
                          enabled: widget.edit,
                          textInputType: TextInputType.none),
                    ],
                  ),
                  AgrupadorCadastro(
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
                      titulo: 'Local',
                      children: [
                        FormCadastro(
                          enabled: widget.edit,
                          controller: cepController,
                          labelText: 'CEP',
                          hintText: '000000-000',
                          inputFormatters: [
                            MaskTextInputFormatter(
                                mask: "#####-###",
                                filter: {"#": RegExp(r'[0-9]')})
                          ],
                          textInputType: TextInputType.text,
                        ),
                        FormCadastro(
                          enabled: widget.edit,
                          controller: ruaController,
                          labelText: 'Endereço',
                          textInputType: TextInputType.text,
                        ),
                        FormCadastro(
                          enabled: widget.edit,
                          controller: complementoRuaController,
                          labelText: 'Complemento',
                          textInputType: TextInputType.text,
                        ),
                        FormCadastro(
                          enabled: widget.edit,
                          controller: bairroController,
                          labelText: 'Bairro',
                          textInputType: TextInputType.text,
                        ),
                        FormCadastro(
                          enabled: widget.edit,
                          controller: cidadeController,
                          labelText: 'Cidade',
                          textInputType: TextInputType.text,
                        ),
                        FormCadastro(
                          enabled: widget.edit,
                          controller: estadoController,
                          labelText: 'Estado',
                          textInputType: TextInputType.text,
                        ),
                      ])
                ],
              ),
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
                      if (_formKey.currentState!.validate()) {
                        FocusManager.instance.primaryFocus?.unfocus();
                        addConsulta();
                        Navigator.pop(context);
                      }
                    },
                    icon: const Icon(
                      Icons.save,
                      color: corPad3,
                      size: 30,
                    ),
                  ),
                )
              : Container(),
        ),
      ),
    );
  }

  Future<void> addConsulta() async {
    widget.consulta!.nome = nomeController.text;

    if (widget.opcao == global.opcaoInclusao &&
        widget.consulta!.nome.isNotEmpty &&
        widget.consulta!.data.isNotEmpty &&
        widget.consulta!.id == '') {
      var med = await MeuFirestore.novaConsultaPaciente(widget.consulta!,
          global.idResponsavelGlobal, global.idPacienteGlobal);
      setState(() {
        widget.consulta = med;
      });
    } else if (widget.consulta!.id.isNotEmpty) {
      MeuFirestore.atualizarConsultaPaciente(
          widget.consulta!, global.idPacienteGlobal);
    }
  }

  void excluirConsulta() {
    MeuFirestore.excluirConsultaPaciente(widget.consulta!.id,
        global.idResponsavelGlobal, global.idPacienteGlobal);
  }
}
