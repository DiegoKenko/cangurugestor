import 'package:cangurugestor/classes/medicamentos.dart';
import 'package:cangurugestor/classes/tarefa.dart';
import 'package:cangurugestor/firebaseUtils/firestore_funcoes.dart';
import 'package:cangurugestor/global.dart';
import 'package:cangurugestor/ui/componentes/adicionar_botao_tarefa.dart';
import 'package:cangurugestor/ui/componentes/agrupador_cadastro.dart';
import 'package:cangurugestor/ui/componentes/app_bar.dart';
import 'package:cangurugestor/ui/componentes/form_cadastro.dart';
import 'package:cangurugestor/ui/componentes/form_cadastro_data_hora.dart';
import 'package:cangurugestor/ui/componentes/styles.dart';
import 'package:flutter/material.dart';
import 'package:cangurugestor/global.dart' as global;
import 'package:intl/intl.dart';

class MedicamentoCadastro extends StatefulWidget {
  final int opcao;
  final int privilegio;
  bool edit;
  bool delete;
  Medicamento? medicamento;
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
  List<TextEditingController> dataControllerList = [];
  List<TextEditingController> horaControllerList = [];
  List<TextEditingController> dataControllerListNova = [];
  List<TextEditingController> horaControllerListNova = [];
  var quantidadeController = TextEditingController();
  var frequenciaQuantidadeController = TextEditingController();
  var observacaoController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String medicamento = 'item';
  String formaDeUso = 'item';
  global.EnumFrequencia frequenciaUmPad = global.EnumFrequencia.minutos;
  List<String> listaMedicamentos = [''];
  List<Tarefa> tarefasSnap = [];
  List<Tarefa> tarefas = [];
  List<Tarefa> tarefasNovas = [];
  bool ativo = false;

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
                      FutureBuilder(
                        future: buscaTarefasMedicamento(),
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
                                        MeuFirestore.excluirTarefasMedicamento(
                                          widget.medicamento!,
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
                      BotaoCadastroTarefa(
                        onPressed: () => adicionarTarefa(),
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
          child: widget.edit && widget.medicamento!.id.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: IconButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          FocusManager.instance.primaryFocus?.unfocus();
                          addMedicamento();
                          Navigator.pop(context);
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
    await MeuFirestore.todosMedicamentos().then((value) {
      setState(() {
        listaMedicamentos = value;
      });
    });
  }

  Future<List<Tarefa>> buscaTarefasMedicamento() async {
    return await MeuFirestore.tarefasMedicamento(
        widget.medicamento!.id, global.idPacienteGlobal);
  }

  Future<void> addMedicamento() async {
    widget.medicamento!.nome = nomeController.text;
    widget.medicamento!.quantidade = double.parse(quantidadeController.text);
    widget.medicamento!.frequenciaQuantidade =
        double.parse(frequenciaQuantidadeController.text);
    widget.medicamento!.frequencia = EnumFrequencia.values.firstWhere(
        (element) => element.name == frequenciaUmPad.name,
        orElse: () => EnumFrequencia.nenhum);

    if (widget.opcao == global.opcaoInclusao &&
        widget.medicamento!.nome.isNotEmpty &&
        widget.medicamento!.dataInicio.isNotEmpty &&
        widget.medicamento!.id.isEmpty) {
      var med = await MeuFirestore.novoMedicamentoPaciente(
          widget.medicamento!, global.idPacienteGlobal);
      // Cria tarefas do medicamento
      await MeuFirestore.criaTarefasMedicamento(med, global.idPacienteGlobal);

      setState(() {
        widget.medicamento = med;
      });
    } else if (widget.medicamento!.id.isNotEmpty) {
      MeuFirestore.atualizarMedicamentoPaciente(
          widget.medicamento!, global.idPacienteGlobal);
    }
  }

  void excluirMedicamento() {
    MeuFirestore.excluirMedicamento(
        widget.medicamento!.id, global.idPacienteGlobal);

    MeuFirestore.excluirTodasTarefasMedicamento(
        widget.medicamento!.id, global.idPacienteGlobal);
  }

  void excluirTarefaMedicametno(Tarefa tarefa) {
    // Exclui tarefas do medicamento
    MeuFirestore.excluirTarefasMedicamento(
        widget.medicamento!, global.idPacienteGlobal, tarefa.id);
  }

  Widget widgetListaMedicamentos() {
    return Container(
      height: 300,
      color: Colors.white,
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
          Expanded(
            child: ListView.builder(
              itemCount: listaMedicamentos.length,
              itemBuilder: (context, index) {
                return Container(
                  decoration: kBoxDecorationSetMedicamento,
                  margin: const EdgeInsets.only(left: 30, right: 30, top: 10),
                  child: ListTile(
                    title: Text(
                      listaMedicamentos[index],
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

  adicionarTarefa() {
    DateTime proxTarefa = DateTime.now();
    if (tarefas.isNotEmpty) {
      DateTime ultTarefa = DateFormat('dd/MM/yyyy').parse(tarefas.last.date);
      DateTime ultTarefaTime = DateFormat('HH:mm').parse(tarefas.last.time);
      proxTarefa = DateTime(ultTarefa.year, ultTarefa.month, ultTarefa.day,
          ultTarefaTime.hour, ultTarefaTime.minute);

      proxTarefa = proxTarefa.add(Duration(
          minutes: enumFrequenciaEmMinutos(widget.medicamento!.frequencia!,
                  widget.medicamento!.frequenciaQuantidade)
              .toInt()));
    }
    setState(() {
      tarefasNovas.add(
        Tarefa(dateTime: proxTarefa),
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
