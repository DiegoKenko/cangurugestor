import 'package:cangurugestor/classes/medicamento.dart';
import 'package:cangurugestor/classes/tarefa.dart';
import 'package:cangurugestor/firebaseUtils/fire_medicamento.dart';
import 'package:cangurugestor/firebaseUtils/fire_tarefa.dart';
import 'package:cangurugestor/global.dart';
import 'package:cangurugestor/ui/componentes/adicionar_botao_tarefa.dart';
import 'package:cangurugestor/ui/componentes/agrupador_cadastro.dart';
import 'package:cangurugestor/ui/componentes/app_bar.dart';
import 'package:cangurugestor/ui/componentes/form_cadastro.dart';
import 'package:cangurugestor/ui/componentes/form_cadastro_data_hora.dart';
import 'package:cangurugestor/ui/componentes/item_tarefa.dart';
import 'package:cangurugestor/ui/componentes/styles.dart';
import 'package:flutter/material.dart';
import 'package:cangurugestor/global.dart' as global;
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class MedicamentoCadastro extends StatefulWidget {
  final int opcao;
  final int privilegio;
  bool edit;
  bool delete;
  Medicamento? medicamento = Medicamento();
  MedicamentoCadastro({
    Key? key,
    this.edit = false,
    this.delete = false,
    this.medicamento,
    required this.opcao,
    required this.privilegio,
  }) : super(key: key) {
    edit = privilegio == global.privilegioGestor;
    delete = privilegio == global.privilegioGestor;
  }

  @override
  State<MedicamentoCadastro> createState() => _MedicamentoCadastroState();
}

class _MedicamentoCadastroState extends State<MedicamentoCadastro> {
  var nomeController = TextEditingController();

  var quantidadeController = TextEditingController();
  var frequenciaQuantidadeController = TextEditingController();
  var observacaoController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String medicamento = 'item';
  String formaDeUso = 'item';
  global.EnumFrequencia frequenciaUmPad = global.EnumFrequencia.minutos;
  List<String> listaMedicamentos = [''];
  bool ativo = false;
  final FirestoreTarefa fireTarefa = FirestoreTarefa();

  final FirestoreMedicamento firestoreMedicamento = FirestoreMedicamento();

  @override
  void initState() {
    super.initState();
    widget.medicamento ??= Medicamento();
    nomeController = TextEditingController(text: widget.medicamento?.nome);
    quantidadeController = TextEditingController(
        text: widget.medicamento?.quantidade.toString() ?? '0');
    frequenciaQuantidadeController = TextEditingController(
        text: widget.medicamento?.frequenciaQuantidade.toString() ?? '0');
    frequenciaUmPad =
        widget.medicamento?.frequencia ?? global.EnumFrequencia.minutos;
    observacaoController =
        TextEditingController(text: widget.medicamento?.observacao);
    TextEditingController(text: widget.medicamento?.observacao);

    buscaMedicamentos();
  }

  @override
  void dispose() {
    nomeController.dispose();
    quantidadeController.dispose();
    frequenciaQuantidadeController.dispose();
    observacaoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCan(
        leading: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context, widget.medicamento);
            },
          ),
        ),
        actions: [
          widget.delete
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: (() {
                      FocusManager.instance.primaryFocus?.unfocus();
                      excluirMedicamento();
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
                    initiallyExpanded: true,
                    leading: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.medication_rounded,
                        size: 40,
                        color: Color.fromARGB(255, 10, 48, 88),
                      ),
                    ),
                    titulo: ' ',
                    children: [
                      FormCadastro(
                        obrigatorio: true,
                        enabled: widget.edit,
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return widgetListaMedicamentos();
                            },
                          );
                        },
                        controller: nomeController,
                        labelText: 'Medicamento',
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
                                  // ignore: body_might_complete_normally_nullable
                                  validator: (p0) {
                                    if (p0 != null) {
                                      if (double.parse(p0) == 0) {
                                        return 'Campo obrigatório';
                                      }
                                    }
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
                      FormCadastro(
                        multiLine: true,
                        enabled: widget.edit,
                        textInputType: TextInputType.text,
                        controller: observacaoController,
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
                      StreamBuilder(
                        stream: buscaTarefasMedicamentoStream(),
                        builder: (context, AsyncSnapshot<List<Tarefa>> snap) {
                          if (snap.hasData) {
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
                                  tempControllerDate.removeListener(() {});
                                  tempControllerTime.removeListener(() {});
                                  tempControllerDate.addListener(() {
                                    snap.data![index]
                                        .setDate(tempControllerDate.text);
                                    fireTarefa.atualizarTarefaPaciente(
                                      snap.data![index],
                                      global.idPacienteGlobal,
                                    );
                                  });
                                  tempControllerTime.addListener(() {
                                    fireTarefa.atualizarTarefaPaciente(
                                      snap.data![index],
                                      global.idPacienteGlobal,
                                    );
                                  });
                                  return FormCadastroDataHora(
                                    enabled: true,
                                    onDismissed: (DismissDirection direction) {
                                      excluirTarefaMedicamento(
                                          snap.data![index]);
                                    },
                                    key: UniqueKey(),
                                    controllerData: tempControllerDate,
                                    controllerHora: tempControllerTime,
                                  );
                                },
                              ),
                              widget.medicamento!.id.isNotEmpty
                                  ? BotaoCadastroTarefa(
                                      onPressed: () {
                                        if (snap.hasData &&
                                            snap.data!.isNotEmpty) {
                                          adicionarTarefa(snap.data!.last);
                                        } else {
                                          adicionarTarefa(
                                              Tarefa(dateTime: DateTime.now()));
                                        }
                                      },
                                    )
                                  : Container(),
                            ]);
                          }
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                      ),
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
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: IconButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          FocusManager.instance.primaryFocus?.unfocus();
                          addMedicamento();
                        }
                      },
                      icon: const Icon(
                        Icons.save,
                        size: 30,
                        color: corPad3,
                      ),
                    ),
                  ),
                )
              : Container(),
        ),
      ),
    );
  }

  buscaMedicamentos() async {
    await firestoreMedicamento.todosMedicamentos().then((value) {
      setState(() {
        listaMedicamentos = value;
      });
    });
  }

  Stream<List<Tarefa>> buscaTarefasMedicamentoStream() {
    return fireTarefa.getTarefasMedicamentoStream(
        widget.medicamento!.id, global.idPacienteGlobal);
  }

  Future<void> addMedicamento() async {
    widget.medicamento!.nome = nomeController.text;
    widget.medicamento!.quantidade = double.parse(quantidadeController.text);
    widget.medicamento!.frequenciaQuantidade =
        double.parse(frequenciaQuantidadeController.text);
    widget.medicamento!.frequencia = EnumFrequencia.values.firstWhere(
        (element) => element.name == frequenciaUmPad.name,
        orElse: () => EnumFrequencia.minutos);

    if (widget.medicamento!.nome.isNotEmpty) {
      if (widget.opcao == opcaoInclusao && widget.medicamento!.id.isEmpty) {
        widget.medicamento = await firestoreMedicamento.novoMedicamentoPaciente(
            widget.medicamento!, global.idPacienteGlobal);
      }
    }
  }

  void excluirMedicamento() {
    if (widget.medicamento!.id.isNotEmpty &&
        global.idPacienteGlobal.isNotEmpty) {
      firestoreMedicamento.excluirMedicamentoPaciente(
          widget.medicamento!.id, global.idPacienteGlobal);

      firestoreMedicamento.excluirTodasTarefasMedicamento(
          widget.medicamento!.id, global.idPacienteGlobal);
    }
  }

  void excluirTarefaMedicamento(Tarefa tarefa) {
    // Exclui tarefas do medicamento
    fireTarefa.excluirTarefa(global.idPacienteGlobal, tarefa.id);
  }

  Widget widgetListaMedicamentos() {
    return Container(
      height: 300,
      color: corPad1.withOpacity(0.1),
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Text(
            'Selecione o medicamento',
            style: kLabelStyle,
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            color: corPad1,
            width: double.infinity,
            height: 2,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: listaMedicamentos.length,
              itemBuilder: (context, index) {
                return Container(
                  decoration: kBoxDecorationSetMedicamento,
                  margin: const EdgeInsets.only(
                      left: 30, right: 30, top: 10, bottom: 10),
                  child: ListTile(
                    title: Text(
                      listaMedicamentos[index].toUpperCase(),
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        nomeController.text = listaMedicamentos[index];
                        medicamento = listaMedicamentos[index];
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

  adicionarTarefa(Tarefa ultimaTarefa) {
    DateTime proxTarefa = DateTime.now();
    DateTime ultTarefa = DateFormat('dd/MM/yyyy').parse(ultimaTarefa.date);
    DateTime ultTarefaTime = DateFormat('HH:mm').parse(ultimaTarefa.time);
    proxTarefa = DateTime(ultTarefa.year, ultTarefa.month, ultTarefa.day,
        ultTarefaTime.hour, ultTarefaTime.minute);

    proxTarefa = proxTarefa.add(Duration(
        minutes: enumFrequenciaEmMinutos(widget.medicamento!.frequencia!,
                widget.medicamento!.frequenciaQuantidade)
            .toInt()));
    fireTarefa.criaTarefas(global.idPacienteGlobal, [
      Tarefa(
        dateTime: proxTarefa,
        nome: widget.medicamento!.nome,
        observacao: widget.medicamento!.observacao,
        idTipo: widget.medicamento!.id,
        tipo: EnumTarefa.medicamento,
      ),
    ]);
  }
}
