import 'package:cangurugestor/model/tarefa.dart';
import 'package:cangurugestor/firebaseUtils/fire_atividade.dart';
import 'package:cangurugestor/firebaseUtils/fire_tarefa.dart';
import 'package:cangurugestor/global.dart';
import 'package:cangurugestor/view/componentes/adicionar_botao_tarefa.dart';
import 'package:cangurugestor/view/componentes/agrupador_cadastro.dart';

import 'package:cangurugestor/view/componentes/form_cadastro.dart';
import 'package:cangurugestor/view/componentes/styles.dart';
import 'package:flutter/material.dart';

import 'package:cangurugestor/global.dart' as global;
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CadastroAtividade extends StatefulWidget {
  const CadastroAtividade({
    Key? key,
  }) : super(key: key);

  @override
  State<CadastroAtividade> createState() => _CadastroAtividadeState();
}

class _CadastroAtividadeState extends State<CadastroAtividade> {
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
  global.EnumIntervalo frequenciaPad = global.EnumIntervalo.minutos;
  List<String> listaAtividades = [];
  String atividade = '';
  bool ativo = false;
  global.EnumIntervalo frequenciaUmPad = global.EnumIntervalo.minutos;
  global.EnumIntervalo duracaoUmPad = global.EnumIntervalo.minutos;
  List<Tarefa> tarefasSnap = [];
  List<Tarefa> tarefas = [];
  List<Tarefa> tarefasNovas = [];
  List<TextEditingController> dataControllerList = [];
  List<TextEditingController> horaControllerList = [];
  List<TextEditingController> dataControllerListNova = [];
  List<TextEditingController> horaControllerListNova = [];

  FirestoreTarefa fireTarefa = FirestoreTarefa();
  FirestoreAtividade firestoreAtividade = FirestoreAtividade();

  @override
  void initState() {
    dataInicioController = TextEditingController();
    dataFimController = TextEditingController();

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
      appBar: AppBar(),
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
                        Icons.pending_actions,
                        size: 40,
                        color: Color.fromARGB(255, 10, 48, 88),
                      ),
                    ),
                    titulo: ' ',
                    children: [
                      FormCadastro(
                        obrigatorio: true,
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
                                  builder: (FormFieldState<String> state) {
                                    return InputDecorator(
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30))),
                                      isEmpty: false,
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton<
                                            global.EnumIntervalo>(
                                          value: frequenciaUmPad,
                                          isDense: true,
                                          onChanged: (x) {
                                            setState(() {
                                              frequenciaUmPad = x!;
                                            });
                                          },
                                          items: global.EnumIntervalo.values
                                              .map((global.EnumIntervalo
                                                  frequencia) {
                                            return DropdownMenuItem<
                                                global.EnumIntervalo>(
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
                                  builder: (FormFieldState<String> state) {
                                    return InputDecorator(
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30))),
                                      isEmpty: false,
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton<
                                            global.EnumIntervalo>(
                                          value: duracaoUmPad,
                                          isDense: true,
                                          onChanged: (x) {
                                            setState(() {
                                              duracaoUmPad = x!;
                                            });
                                          },
                                          items: global.EnumIntervalo.values
                                              .map((global.EnumIntervalo
                                                  frequencia) {
                                            return DropdownMenuItem<
                                                global.EnumIntervalo>(
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
                        textInputType: TextInputType.text,
                        controller: descricaoController,
                        labelText: 'Observação',
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
          child: Center(
            child: IconButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  FocusManager.instance.primaryFocus?.unfocus();
                }
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

  void excluirAtividade() {
    /*   if (false) {
      firestoreAtividade.excluirAtividadePaciente('', global.idPacienteGlobal);
    } */
  }

  void buscaAtividade() async {
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

  adicionarTarefa() {
    DateTime proxTarefa = DateTime.now();
    if (tarefas.isNotEmpty) {
      DateTime ultTarefa = DateFormat('dd/MM/yyyy').parse(tarefas.last.date);
      DateTime ultTarefaTime = DateFormat('HH:mm').parse(tarefas.last.time);
      proxTarefa = DateTime(ultTarefa.year, ultTarefa.month, ultTarefa.day,
          ultTarefaTime.hour, ultTarefaTime.minute);

      /*  proxTarefa = proxTarefa.add(Duration(
          minutes: enumFrequenciaEmMinutos(widget.atividade!.frequenciaMedida,
                  widget.atividade!.frequenciaQuantidade)
              .toInt())); */
    }
    setState(() {
      tarefasNovas.add(
        Tarefa(
          dateTime: proxTarefa,
          nome: '',
          observacao: '',
          idTipo: '',
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
