import 'package:cangurugestor/classes/atividade.dart';
import 'package:cangurugestor/firebaseUtils/firestore_funcoes.dart';
import 'package:cangurugestor/ui/componentes/agrupador_cadastro.dart';
import 'package:cangurugestor/ui/componentes/app_bar.dart';
import 'package:cangurugestor/ui/componentes/form_cadastro.dart';
import 'package:cangurugestor/ui/componentes/form_cadastro_data.dart';
import 'package:cangurugestor/ui/componentes/form_cadastro_hora.dart';
import 'package:cangurugestor/ui/componentes/styles.dart';
import 'package:flutter/material.dart';

import 'package:cangurugestor/global.dart' as global;

class AtividadeCadastro extends StatefulWidget {
  Atividade? atividade;
  final int opcao;
  final int privilegio;
  bool edit;
  bool delete;
  AtividadeCadastro(
      {Key? key,
      this.atividade,
      this.edit = false,
      this.delete = false,
      required this.privilegio,
      required this.opcao})
      : super(key: key) {
    edit = privilegio == global.privilegioGestor;
    delete = privilegio == global.privilegioGestor;
  }

  @override
  State<AtividadeCadastro> createState() => _AtividadeCadastroState();
}

class _AtividadeCadastroState extends State<AtividadeCadastro> {
  var nomeController = TextEditingController();
  var dataInicioController = TextEditingController();
  var dataFimController = TextEditingController();
  var horaController = TextEditingController();
  var descricaoController = TextEditingController();
  var cuidadorController = TextEditingController();
  var frequenciaController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  global.EnumFrequencia frequenciaPad = global.EnumFrequencia.minutos;
  List<String> listaAtividades = [];
  String atividade = '';
  bool ativo = false;

  @override
  void initState() {
    widget.atividade ??= Atividade();
    dataInicioController = TextEditingController();
    dataFimController = TextEditingController();
    frequenciaController =
        TextEditingController(text: widget.atividade!.frequencia);
    horaController = TextEditingController(text: widget.atividade?.hora);
    nomeController = TextEditingController(text: widget.atividade?.nome);
    descricaoController =
        TextEditingController(text: widget.atividade?.descricao);
    buscaAtividade();
    super.initState();
  }

  @override
  void dispose() {
    dataInicioController.dispose();
    dataFimController.dispose();
    nomeController.dispose();
    horaController.dispose();
    descricaoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCan(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, widget.atividade);
          },
        ),
        actions: [
          widget.edit
              ? IconButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      FocusManager.instance.primaryFocus?.unfocus();
                      addAtividade();
                      Navigator.pop(context);
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
                    excluirAtividade();
                    Navigator.pop(context);
                  }),
                )
              : Container(),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 30, bottom: 30),
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
                        Icons.pending_actions,
                        size: 40,
                        color: Color.fromARGB(255, 10, 48, 88),
                      ),
                    ),
                    titulo: ' ',
                    children: [
                      FormCadastro(
                        obrigatorio: true,
                        enabled: widget.edit,
                        controller: nomeController,
                        labelText: 'Ativdade',
                        onTap: () {
                          showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return widgetListaAtividades();
                              });
                        },
                      ),
                      FormCadastroData(
                          obrigatorio: true,
                          controller: dataInicioController,
                          labelText: 'Início',
                          dataPrimeira: DateTime.now(),
                          dataInicial: DateTime.now(),
                          dataUltima: DateTime(DateTime.now().year + 10),
                          enabled: widget.edit,
                          textInputType: TextInputType.none),
                      FormCadastroData(
                          obrigatorio: true,
                          controller: dataFimController,
                          dataPrimeira: DateTime.now(),
                          dataInicial: DateTime.now(),
                          dataUltima: DateTime(DateTime.now().year + 10),
                          labelText: 'Fim',
                          enabled: widget.edit,
                          textInputType: TextInputType.none),
                      FormCadastroHora(
                          obrigatorio: true,
                          controller: horaController,
                          labelText: 'Hora inicial',
                          enabled: widget.edit,
                          textInputType: TextInputType.none),
                      Padding(
                        padding: const EdgeInsets.only(top: 20, bottom: 20),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 7,
                              child: SizedBox(
                                height: 80,
                                child: FormCadastro(
                                  obrigatorio: true,
                                  enabled: widget.edit,
                                  borda: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30)),
                                  controller: frequenciaController,
                                  labelText: 'a cada:',
                                  textInputType: TextInputType.number,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              flex: 8,
                              child: SizedBox(
                                height: 60,
                                child: FormField<String>(
                                  builder: (FormFieldState<String> state) {
                                    return InputDecorator(
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30))),
                                      isEmpty: false,
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton<
                                            global.EnumFrequencia>(
                                          value: frequenciaPad,
                                          isDense: true,
                                          onChanged: (x) {
                                            setState(() {
                                              frequenciaPad = x!;
                                            });
                                          },
                                          items: global.EnumFrequencia.values
                                              .map((global.EnumFrequencia
                                                  frequencia) {
                                            return DropdownMenuItem<
                                                global.EnumFrequencia>(
                                              alignment: Alignment.centerLeft,
                                              value: frequencia,
                                              child: Text(
                                                global
                                                    .describeEnum(frequencia)
                                                    .toUpperCase(),
                                                style: kLabelStyle,
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      FormCadastro(
                        multiLine: true,
                        enabled: widget.edit,
                        textInputType: TextInputType.text,
                        controller: descricaoController,
                        labelText: 'Observação',
                      ),
                    ],
                  ),
                ],
              ),
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

  Future<void> addAtividade() async {
    widget.atividade!.nome = nomeController.text;

    if (widget.opcao == global.opcaoInclusao &&
        widget.atividade!.nome!.isNotEmpty &&
        widget.atividade!.data.isNotEmpty &&
        widget.atividade!.id == '') {
      var med = await MeuFirestore.novaAtividadePaciente(widget.atividade!,
          global.idResponsavelGlobal, global.idPacienteGlobal);
      setState(() {
        widget.atividade = med;
      });
    } else if (widget.atividade!.id.isNotEmpty) {
      MeuFirestore.atualizarAtividadePaciente(
          widget.atividade!, global.idPacienteGlobal);
    }
  }

  void excluirAtividade() {
    if (widget.atividade!.id.isNotEmpty) {
      MeuFirestore.excluirAtividadePaciente(
          widget.atividade!.id, global.idPacienteGlobal);
    }
  }

  buscaAtividade() async {
    await MeuFirestore.todasAtividades().then((value) {
      setState(() {
        listaAtividades = value;
      });
    });
  }

  Widget widgetListaAtividades() {
    return Container(
      height: 300,
      color: Colors.white,
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Text(
            'Selecione a atividade',
            style: kLabelStyle,
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: listaAtividades.length,
              itemBuilder: (context, index) {
                return Container(
                  decoration: kBoxDecorationSetMedicamento,
                  margin: const EdgeInsets.only(left: 30, right: 30, top: 10),
                  child: ListTile(
                    title: Text(
                      listaAtividades[index],
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        nomeController.text = listaAtividades[index];
                        atividade = listaAtividades[index];
                      });
                      Navigator.pop(context);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
