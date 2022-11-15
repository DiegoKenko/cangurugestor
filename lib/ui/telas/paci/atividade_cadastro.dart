import 'package:cangurugestor/classes/atividade.dart';
import 'package:cangurugestor/classes/tarefa.dart';
import 'package:cangurugestor/firebaseUtils/fire_atividade.dart';
import 'package:cangurugestor/firebaseUtils/fire_tarefa.dart';
import 'package:cangurugestor/global.dart';
import 'package:cangurugestor/ui/componentes/adicionar_botao_tarefa.dart';
import 'package:cangurugestor/ui/componentes/agrupador_cadastro.dart';
import 'package:cangurugestor/ui/componentes/app_bar.dart';
import 'package:cangurugestor/ui/componentes/form_cadastro.dart';
import 'package:cangurugestor/ui/componentes/form_cadastro_data_hora.dart';
import 'package:cangurugestor/ui/componentes/styles.dart';
import 'package:flutter/material.dart';

import 'package:cangurugestor/global.dart' as global;
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class AtividadeCadastro extends StatefulWidget {
  Atividade? atividade = Atividade();
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
  var frequenciaQuantidadeController = TextEditingController();
  var duracaoQuantidadeController = TextEditingController();
  var observacaoController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  global.EnumFrequencia frequenciaPad = global.EnumFrequencia.minutos;
  List<String> listaAtividades = [];
  String atividade = '';
  bool ativo = false;
  global.EnumFrequencia frequenciaUmPad = global.EnumFrequencia.minutos;
  global.EnumFrequencia duracaoUmPad = global.EnumFrequencia.minutos;
  List<Tarefa> tarefasSnap = [];
  List<Tarefa> tarefas = [];
  List<Tarefa> tarefasNovas = [];
  List<TextEditingController> dataControllerList = [];
  List<TextEditingController> horaControllerList = [];
  List<TextEditingController> dataControllerListNova = [];
  List<TextEditingController> horaControllerListNova = [];

  FirestoreTarefa firestoreTarefa = FirestoreTarefa();
  FirestoreAtividade firestoreAtividade = FirestoreAtividade();

  @override
  void initState() {
    widget.atividade ??= Atividade();
    dataInicioController = TextEditingController();
    dataFimController = TextEditingController();
    horaController = TextEditingController(text: widget.atividade?.hora);
    nomeController = TextEditingController(text: widget.atividade?.nome);
    descricaoController =
        TextEditingController(text: widget.atividade?.descricao);
    observacaoController =
        TextEditingController(text: widget.atividade?.observacao);
    duracaoQuantidadeController = TextEditingController(
        text: widget.atividade?.duracaoQuantidade.toString());
    frequenciaQuantidadeController = TextEditingController(
        text: widget.atividade?.frequenciaQuantidade.toString() ?? '0');
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
    duracaoQuantidadeController.dispose();
    observacaoController.dispose();
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
          widget.delete
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: (() {
                      FocusManager.instance.primaryFocus?.unfocus();
                      excluirAtividade();
                      Navigator.pop(context);
                    }),
                  ),
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
                        labelText: 'Atividade',
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return widgetListaAtividades();
                            },
                          );
                        },
                      ),
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
                                  controller: frequenciaQuantidadeController,
                                  labelText: 'a cada:',
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    FilteringTextInputFormatter.deny(
                                        RegExp("[.]")),
                                    FilteringTextInputFormatter.deny(
                                        RegExp("[,]"))
                                  ],
                                  textInputType:
                                      const TextInputType.numberWithOptions(
                                    decimal: false,
                                    signed: false,
                                  ),
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
                                  validator: (p0) {
                                    if (p0 != null) {
                                      if (double.parse(p0) == 0) {
                                        return 'Campo obrigatório';
                                      }
                                    }
                                    return null;
                                  },
                                  enabled: widget.edit,
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
                                          value: frequenciaUmPad,
                                          isDense: true,
                                          onChanged: (x) {
                                            setState(() {
                                              frequenciaUmPad = x!;
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
                                  controller: duracaoQuantidadeController,
                                  labelText: 'duração:',
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    FilteringTextInputFormatter.deny(
                                        RegExp("[.]")),
                                    FilteringTextInputFormatter.deny(
                                        RegExp("[,]"))
                                  ],
                                  textInputType:
                                      const TextInputType.numberWithOptions(
                                    decimal: false,
                                    signed: false,
                                  ),
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
                                  validator: (p0) {
                                    if (p0 != null) {
                                      if (double.parse(p0) == 0) {
                                        return 'Campo obrigatório';
                                      }
                                    }
                                    return null;
                                  },
                                  enabled: widget.edit,
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
                                          value: duracaoUmPad,
                                          isDense: true,
                                          onChanged: (x) {
                                            setState(() {
                                              duracaoUmPad = x!;
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
                        future: buscaTarefasAtividade(),
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
                      widget.atividade!.id.isNotEmpty
                          ? BotaoCadastroTarefa(
                              onPressed: () => adicionarTarefa(),
                            )
                          : Container(),
                    ],
                  )
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
                        addAtividade();
                      }
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

  Future<void> addAtividade() async {
    widget.atividade!.nome = nomeController.text;
    widget.atividade!.descricao = descricaoController.text;
    widget.atividade!.duracaoQuantidade = double.parse(
      duracaoQuantidadeController.text,
    );
    widget.atividade!.duracaoMedida = duracaoUmPad;
    widget.atividade!.observacao = observacaoController.text;
    widget.atividade!.frequenciaMedida = frequenciaUmPad;
    widget.atividade!.frequenciaQuantidade =
        double.parse(frequenciaQuantidadeController.text);
    widget.atividade!.duracaoMedida = duracaoUmPad;
    widget.atividade!.duracaoQuantidade =
        double.parse(duracaoQuantidadeController.text);

    if (widget.atividade!.nome.isNotEmpty) {
      if (widget.opcao == opcaoInclusao && widget.atividade!.id.isEmpty) {
        widget.atividade = await firestoreAtividade.novaAtividadePaciente(
            widget.atividade!, global.idPacienteGlobal);
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

  void excluirAtividade() {
    if (widget.atividade!.id.isNotEmpty) {
      firestoreAtividade.excluirAtividadePaciente(
          widget.atividade!.id, global.idPacienteGlobal);
    }
  }

  buscaAtividade() async {
    await firestoreAtividade.todasAtividades().then((value) {
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

  Future<List<Tarefa>> buscaTarefasAtividade() async {
    return await firestoreTarefa.getTarefasAtividade(
        widget.atividade!.id, global.idPacienteGlobal);
  }

  adicionarTarefa() {
    DateTime proxTarefa = DateTime.now();
    if (tarefas.isNotEmpty) {
      DateTime ultTarefa = DateFormat('dd/MM/yyyy').parse(tarefas.last.date);
      DateTime ultTarefaTime = DateFormat('HH:mm').parse(tarefas.last.time);
      proxTarefa = DateTime(ultTarefa.year, ultTarefa.month, ultTarefa.day,
          ultTarefaTime.hour, ultTarefaTime.minute);

      proxTarefa = proxTarefa.add(Duration(
          minutes: enumFrequenciaEmMinutos(widget.atividade!.frequenciaMedida,
                  widget.atividade!.frequenciaQuantidade)
              .toInt()));
    }
    setState(() {
      tarefasNovas.add(
        Tarefa(
          dateTime: proxTarefa,
          nome: widget.atividade!.nome,
          descricao: widget.atividade!.descricao,
          observacao: widget.atividade!.observacao,
          idTipo: widget.atividade!.id,
          tipo: EnumTarefa.atividade,
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
}
