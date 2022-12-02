import 'package:cangurugestor/classes/consulta.dart';
import 'package:cangurugestor/classes/tarefa.dart';
import 'package:cangurugestor/firebaseUtils/fire_consulta.dart';
import 'package:cangurugestor/firebaseUtils/fire_tarefa.dart';
import 'package:cangurugestor/global.dart';
import 'package:cangurugestor/ui/componentes/adicionar_botao_tarefa.dart';
import 'package:cangurugestor/ui/componentes/agrupador_cadastro.dart';
import 'package:cangurugestor/ui/componentes/app_bar.dart';
import 'package:cangurugestor/ui/componentes/form_cadastro.dart';
import 'package:cangurugestor/ui/componentes/form_cadastro_data_hora.dart';
import 'package:cangurugestor/ui/componentes/styles.dart';
import 'package:cangurugestor/utils/cep_api.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import 'package:cangurugestor/global.dart' as global;

class ConsultaCadastro extends StatefulWidget {
  Consulta? consulta = Consulta();
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
  TextEditingController medicoController = TextEditingController();
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

  final FirestoreTarefa fireTarefa = FirestoreTarefa();

  @override
  void initState() {
    widget.consulta ??= Consulta();
    nomeController = TextEditingController(text: widget.consulta?.nome);
    medicoController = TextEditingController(text: widget.consulta?.medico);
    cepController = TextEditingController(text: widget.consulta?.cep);
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
    ruaController = TextEditingController(text: widget.consulta?.rua);
    bairroController = TextEditingController(text: widget.consulta?.bairro);
    numeroRuaController = TextEditingController(text: widget.consulta?.numero);
    complementoRuaController =
        TextEditingController(text: widget.consulta?.complementoRua);
    cidadeController = TextEditingController(text: widget.consulta?.cidade);
    estadoController = TextEditingController(text: widget.consulta?.estado);

    super.initState();
  }

  @override
  void dispose() {
    nomeController.dispose();
    medicoController.dispose();
    cepController.dispose();
    ruaController.dispose();
    bairroController.dispose();
    numeroRuaController.dispose();
    complementoRuaController.dispose();
    cidadeController.dispose();
    estadoController.dispose();

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
                    initiallyExpanded: true,
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
                      StreamBuilder(
                        stream: fireTarefa.getTarefasConsulta(
                            widget.consulta!.id, global.idPacienteGlobal),
                        builder: (context, AsyncSnapshot<List<Tarefa>> snap) {
                          if (snap.hasData) {
                            if (snap.data!.isNotEmpty) {
                              return Column(children: [
                                ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: snap.data!.length,
                                  itemBuilder: (context, index) {
                                    TextEditingController tempControllerDate =
                                        TextEditingController(
                                      text: snap.data![index].date,
                                    );
                                    TextEditingController tempControllerTime =
                                        TextEditingController(
                                      text: snap.data![index].time,
                                    );

                                    return FormCadastroDataHora(
                                      onTimeChanged: (time) {
                                        snap.data![index]
                                            .setTimeFromTimeOfDay(time);
                                        fireTarefa.atualizarTarefaPaciente(
                                          snap.data![index],
                                          global.idPacienteGlobal,
                                        );
                                      },
                                      onDateChanged: (date) {
                                        snap.data![index]
                                            .setDateFromDateTime(date);
                                        fireTarefa.atualizarTarefaPaciente(
                                          snap.data![index],
                                          global.idPacienteGlobal,
                                        );
                                      },
                                      enabled: true,
                                      onDismissed:
                                          (DismissDirection direction) {
                                        excluirTarefaConsulta(
                                            snap.data![index]);
                                      },
                                      key: UniqueKey(),
                                      controllerData: tempControllerDate,
                                      controllerHora: tempControllerTime,
                                    );
                                  },
                                ),
                                widget.consulta!.id.isNotEmpty
                                    ? BotaoCadastroTarefa(
                                        onPressed: () {
                                          if (snap.hasData &&
                                              snap.data!.isNotEmpty) {
                                            adicionarTarefa(snap.data!.last);
                                          } else {
                                            adicionarTarefa(Tarefa(
                                                dateTime: DateTime.now()));
                                          }
                                        },
                                      )
                                    : Container(),
                              ]);
                            }
                          }
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                      ),
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
          child: widget.edit && widget.consulta!.id.isEmpty
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
        firestoreTarefa.criaTarefas(global.idPacienteGlobal, tarefasNovas);
        tarefasNovas = [];
      } else {
        firestoreTarefa.criaTarefas(global.idPacienteGlobal, tarefasNovas);
        tarefasNovas = [];
      }
      setState(() {});
    }
  }

  void excluirConsulta() {
    firestoreConsulta.excluirConsultaPaciente(widget.consulta!.id,
        global.idResponsavelGlobal, global.idPacienteGlobal);
  }

  void adicionarTarefa(Tarefa ultimaTarefa) {
    DateTime proxTarefa = DateTime.now();
    DateTime ultTarefa = DateFormat('dd/MM/yyyy').parse(ultimaTarefa.date);
    DateTime ultTarefaTime = DateFormat('HH:mm').parse(ultimaTarefa.time);
    proxTarefa = DateTime(ultTarefa.year, ultTarefa.month, ultTarefa.day,
        ultTarefaTime.hour, ultTarefaTime.minute);

    proxTarefa = proxTarefa.add(Duration(
        minutes: enumFrequenciaEmMinutos(EnumFrequencia.dias, 7).toInt()));
    fireTarefa.criaTarefas(global.idPacienteGlobal, [
      Tarefa(
        dateTime: proxTarefa,
        nome: widget.consulta!.nome,
        observacao: widget.consulta!.observacao,
        idTipo: widget.consulta!.id,
        tipo: EnumTarefa.consulta,
      ),
    ]);
  }

  void excluirTarefaConsulta(Tarefa tarefa) {
    // Exclui tarefas do medicamento
    fireTarefa.excluirTarefa(global.idPacienteGlobal, tarefa.id);
  }
}
