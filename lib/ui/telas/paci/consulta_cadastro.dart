import 'package:cangurugestor/classes/consulta.dart';
import 'package:cangurugestor/classes/tarefa.dart';
import 'package:cangurugestor/firebaseUtils/fire_consulta.dart';
import 'package:cangurugestor/firebaseUtils/fire_consulta.dart';
import 'package:cangurugestor/firebaseUtils/fire_tarefa.dart';
import 'package:cangurugestor/global.dart';
import 'package:cangurugestor/ui/componentes/adicionar_botao_tarefa.dart';
import 'package:cangurugestor/ui/componentes/agrupador_cadastro.dart';
import 'package:cangurugestor/ui/componentes/app_bar.dart';
import 'package:cangurugestor/ui/componentes/form_cadastro.dart';
import 'package:cangurugestor/ui/componentes/form_cadastro_data.dart';
import 'package:cangurugestor/ui/componentes/form_cadastro_data_hora.dart';
import 'package:cangurugestor/ui/componentes/form_cadastro_hora.dart';
import 'package:cangurugestor/ui/componentes/styles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
  final FirestoreTarefa firestoreTarefa = FirestoreTarefa();
  final FirestoreConsulta firestoreConsulta = FirestoreConsulta();
  List<Tarefa> tarefasSnap = [];
  List<Tarefa> tarefas = [];
  List<Tarefa> tarefasNovas = [];
  List<TextEditingController> dataControllerList = [];
  List<TextEditingController> horaControllerList = [];
  List<TextEditingController> dataControllerListNova = [];
  List<TextEditingController> horaControllerListNova = [];

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
                        textInputType: TextInputType.text,
                      ),
                    ],
                  ),
                  AgrupadorCadastro(
                    initiallyExpanded: true,
                    leading: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.schedule,
                        size: 40,
                        color: Color.fromARGB(255, 10, 48, 88),
                      ),
                    ),
                    titulo: 'Agenda',
                    children: [
                      FutureBuilder(
                        future: buscaTarefasConsulta(),
                        builder: (context, AsyncSnapshot<List<Tarefa>> snap) {
                          if (snap.hasData) {
                            tarefasSnap = snap.data!;
                            tarefas = [...tarefasSnap, ...tarefasNovas];
                            horaControllerList =
                                List<TextEditingController>.generate(
                              tarefas.length,
                              (index) => TextEditingController(
                                text: tarefas[index].time,
                              ),
                            );
                            dataControllerList =
                                List<TextEditingController>.generate(
                              tarefas.length,
                              (index) => TextEditingController(
                                  text: tarefas[index].date),
                            );
                            for (var i = 0; i < tarefasSnap.length; i++) {
                              dataControllerList.add(TextEditingController(
                                  text: snap.data![i].date));
                              horaControllerList.add(TextEditingController(
                                  text: snap.data![i].time));
                            }
                            return ListView.builder(
                              shrinkWrap: true,
                              itemCount: tarefas.length,
                              itemBuilder: (context, index) {
                                return FormCadastroDataHora(
                                  enabled:
                                      tarefas[index].id.isEmpty ? true : false,
                                  onDismissed: (DismissDirection direction) {
                                    setState(() {
                                      dataControllerList.removeAt(index);
                                      horaControllerList.removeAt(index);
                                      if (tarefas[index].id.isEmpty) {
                                        tarefasNovas.remove(tarefas[index]);
                                        tarefas.removeAt(index);
                                      } else {
                                        firestoreTarefa.excluirTarefa(
                                          global.idPacienteGlobal,
                                          tarefas[index].id,
                                        );
                                      }
                                    });
                                  },
                                  key: UniqueKey(),
                                  controllerData: dataControllerList[index],
                                  controllerHora: horaControllerList[index],
                                );
                              },
                            );
                          } else {
                            return Container();
                          }
                        },
                      ),
                      widget.consulta!.id.isNotEmpty
                          ? BotaoCadastroTarefa(
                              onPressed: () => adicionarTarefa(),
                            )
                          : Container(),
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

    if (widget.consulta!.nome.isNotEmpty) {
      if (widget.opcao == opcaoInclusao && widget.consulta!.id.isEmpty) {
        widget.consulta = await firestoreConsulta.novaConsultaPaciente(
            widget.consulta!, global.idPacienteGlobal);
        await firestoreTarefa.criaTarefas(
            global.idPacienteGlobal, tarefasNovas);
        tarefasNovas = [];
      } else {
        await firestoreTarefa.criaTarefas(
            global.idPacienteGlobal, tarefasNovas);
        tarefasNovas = [];
      }
      setState(() {});
    }
  }

  void excluirConsulta() {
    firestoreConsulta.excluirConsultaPaciente(widget.consulta!.id,
        global.idResponsavelGlobal, global.idPacienteGlobal);
  }

  adicionarTarefa() {
    DateTime proxTarefa = DateTime.now();
    if (tarefas.isNotEmpty) {
      DateTime ultTarefa = DateFormat('dd/MM/yyyy').parse(tarefas.last.date);
      DateTime ultTarefaTime = DateFormat('HH:mm').parse(tarefas.last.time);
      proxTarefa = DateTime(ultTarefa.year, ultTarefa.month, ultTarefa.day,
          ultTarefaTime.hour, ultTarefaTime.minute);

      proxTarefa = proxTarefa.add(
        Duration(
          minutes: enumFrequenciaEmMinutos(EnumFrequencia.dias, 7).toInt(),
        ),
      );
    }
    setState(() {
      tarefasNovas.add(
        Tarefa(
          dateTime: proxTarefa,
          nome: widget.consulta!.nome,
          descricao: widget.consulta!.descricao,
          observacao: widget.consulta!.observacao,
          idTipo: widget.consulta!.id,
          tipo: EnumTarefa.consulta,
        ),
      );
      horaControllerListNova.clear();
      dataControllerListNova.clear();
      for (var i = 0; i < tarefasNovas.length; i++) {
        dataControllerListNova
            .add(TextEditingController(text: tarefasNovas[i].date));
        horaControllerListNova
            .add(TextEditingController(text: tarefasNovas[i].time));
      }
    });
  }

  Future<List<Tarefa>> buscaTarefasConsulta() async {
    return await firestoreTarefa.getTarefasAtividade(
        widget.consulta!.id, global.idPacienteGlobal);
  }
}
