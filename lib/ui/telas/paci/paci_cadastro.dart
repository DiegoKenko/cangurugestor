import 'package:cangurugestor/classes/atividade.dart';
import 'package:cangurugestor/classes/consulta.dart';
import 'package:cangurugestor/classes/cuidador.dart';
import 'package:cangurugestor/classes/medicamento.dart';
import 'package:cangurugestor/classes/paciente.dart';
import 'package:cangurugestor/classes/tarefa.dart';
import 'package:cangurugestor/firebaseUtils/fire_paciente.dart';
import 'package:cangurugestor/firebaseUtils/fire_tarefa.dart';
import 'package:cangurugestor/ui/componentes/adicionar_botao_rpc.dart';
import 'package:cangurugestor/ui/componentes/agrupador_cadastro.dart';
import 'package:cangurugestor/ui/componentes/animated_page_transition.dart';
import 'package:cangurugestor/ui/componentes/app_bar.dart';
import 'package:cangurugestor/ui/componentes/form_cadastro.dart';
import 'package:cangurugestor/ui/componentes/form_cadastro_data.dart';
import 'package:cangurugestor/ui/componentes/header_cadastro.dart';
import 'package:cangurugestor/ui/componentes/item_atividade.dart';
import 'package:cangurugestor/ui/componentes/item_consulta.dart';
import 'package:cangurugestor/ui/componentes/item_cuidador.dart';
import 'package:cangurugestor/ui/componentes/item_medicamento.dart';
import 'package:cangurugestor/ui/componentes/item_tarefa.dart';
import 'package:cangurugestor/ui/componentes/styles.dart';
import 'package:cangurugestor/ui/telas/paci/atividade_cadastro.dart';
import 'package:cangurugestor/ui/telas/paci/consulta_cadastro.dart';
import 'package:cangurugestor/ui/telas/paci/medicamento_cadastro.dart';
import 'package:flutter/material.dart';
import 'package:cangurugestor/global.dart' as global;
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class CadastroPaciente extends StatefulWidget {
  Paciente? paciente = Paciente();
  final int opcao;
  final int privilegio;
  bool edit = false;
  bool delete = false;
  CadastroPaciente({
    Key? key,
    this.paciente,
    required this.opcao,
    required this.privilegio,
  }) : super(key: key) {
    edit = privilegio == global.privilegioGestor;
    delete = privilegio == global.privilegioGestor;
    paciente?.idResponsavel = global.idResponsavelGlobal;
    if (opcao == global.opcaoAlteracao || opcao == global.opcaoVisualizacao) {
      global.idPacienteGlobal = paciente!.id;
    }
    if (opcao == global.opcaoInclusao) {
      paciente = Paciente();
      paciente!.medicamentos = [];
      paciente!.consultas = [];
      paciente!.atividades = [];
      paciente!.idResponsavel = global.idResponsavelGlobal;
    }
  }

  @override
  State<CadastroPaciente> createState() => _CadastroPacienteState();
}

class _CadastroPacienteState extends State<CadastroPaciente> {
  var cpfController = TextEditingController();
  var nomeController = TextEditingController();
  var nascimentoController = TextEditingController();
  var emailController = TextEditingController();
  var telefoneController = TextEditingController();
  var senhaController = TextEditingController();
  final _formKeyDadosPessoais = GlobalKey<FormState>();
  bool ativo = true;
  bool editar = true;
  List<Widget> consultasWidget = [];
  List<Widget> medicamentosWidget = [];
  List<Widget> atividadesWidget = [];
  List<Widget> tarefasWidget = [];
  List<Widget> cuidadoresWidget = [];
  final FirestorePaciente firestorePaciente = FirestorePaciente();
  final FirestoreTarefa firestoreTarefa = FirestoreTarefa();

  @override
  void initState() {
    ativo = widget.paciente!.ativo;
    cpfController = TextEditingController(text: widget.paciente?.cpf);
    nomeController = TextEditingController(text: widget.paciente?.nome);
    nascimentoController =
        TextEditingController(text: widget.paciente?.nascimento.toString());
    emailController = TextEditingController(text: widget.paciente?.email);
    telefoneController = TextEditingController(text: widget.paciente?.telefone);

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
            color: widget.paciente!.id.isEmpty ? Colors.red : Colors.white,
          ),
          onPressed: () {
            if (widget.paciente!.id.isEmpty) {
              Navigator.pop(context);
            } else {
              Navigator.pop(context, widget.paciente);
            }
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: widget.delete
                ? IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: (() {
                      FocusManager.instance.primaryFocus?.unfocus();
                      excluirPaciente();
                      Navigator.pop(context, widget.paciente);
                    }),
                  )
                : Container(),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 20,
            bottom: 20,
          ),
          child: Center(
            child: ListView(
              children: [
                Center(
                  child: Column(
                    children: [
                      widget.paciente != null
                          ? HeaderCadastro(
                              texto:
                                  '${widget.paciente!.nome} ${widget.paciente!.sobrenome}',
                              titulo: 'Paciente',
                              subTitulo: '${widget.paciente!.idade} anos',
                            )
                          : Container(),
                    ],
                  ),
                ),
                widget.paciente!.id.isNotEmpty
                    ? tarefaGroup()
                    : const SizedBox(),
                dadosPessoaisGroup(),
                widget.paciente!.id.isNotEmpty
                    ? medicamentoGroup()
                    : const SizedBox(),
                widget.paciente!.id.isNotEmpty
                    ? atividadeGroup()
                    : const SizedBox(),
                widget.paciente!.id.isNotEmpty
                    ? consultaGroup()
                    : const SizedBox(),
                widget.paciente!.id.isNotEmpty
                    ? cuidadorGroup()
                    : const SizedBox(),
                widget.edit ? configuracaoGroup() : const SizedBox(),
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
                      if (_formKeyDadosPessoais.currentState!.validate()) {
                        addPaciente();
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

  dadosPessoaisGroup() {
    return Form(
      key: _formKeyDadosPessoais,
      child: AgrupadorCadastro(
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
          widget.edit
              ? FormCadastro(
                  obrigatorio: true,
                  enabled: widget.edit,
                  controller: cpfController,
                  labelText: 'CPF',
                  inputFormatters: [
                    MaskTextInputFormatter(
                        mask: "###.###.###-##", filter: {"#": RegExp(r'[0-9]')})
                  ],
                  textInputType: TextInputType.number,
                )
              : Container(),
          FormCadastro(
            obrigatorio: true,
            enabled: widget.edit,
            controller: nomeController,
            labelText: 'Nome',
            textInputType: TextInputType.text,
          ),
          FormCadastroData(
            dataPrimeira: DateTime(DateTime.now().year - 100),
            obrigatorio: true,
            dataInicial: DateTime(DateTime.now().year - 10),
            dataUltima: DateTime(DateTime.now().year),
            enabled: widget.edit,
            controller: nascimentoController,
            labelText: 'Data de nascimento',
            textInputType: TextInputType.none,
          ),
        ],
      ),
    );
  }

  configuracaoGroup() {
    return AgrupadorCadastro(
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
      titulo: 'Configurações',
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
                  widget.paciente?.ativo = ativo;
                });
              },
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 20),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Text(
                'ID:  ${widget.paciente!.id}',
                style: const TextStyle(color: corPad1, fontSize: 15),
              ),
            ),
          ),
        ),
      ],
    );
  }

  StreamBuilder<List<Consulta>> consultaGroup() {
    return StreamBuilder(
        stream: firestorePaciente.todasConsultasPaciente(widget.paciente!.id),
        builder: (context, AsyncSnapshot<List<Consulta>> builder) {
          if (builder.hasData) {
            consultasWidget = [];
            for (var consulta in builder.data!) {
              consultasWidget.add(
                ItemConsulta(
                  consulta: consulta,
                  onTap: () {
                    Navigator.of(context).push(
                      AnimatedPageTransition(
                        page: ConsultaCadastro(
                          privilegio: widget.privilegio,
                          consulta: consulta,
                          opcao: global.opcaoAlteracao,
                        ),
                      ),
                    );
                    setState(() {});
                  },
                ),
              );
            }
            widget.edit
                ? consultasWidget.add(botaoAdicionarConsulta())
                : Container();
            return AgrupadorCadastro(
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
              titulo: 'Consultas',
              children: consultasWidget,
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }

  StreamBuilder<List<Atividade>> atividadeGroup() {
    return StreamBuilder(
        stream: firestorePaciente.todasAtividadesPaciente(widget.paciente!.id),
        builder: (context, AsyncSnapshot<List<Atividade>> builder) {
          if (builder.hasData) {
            atividadesWidget = [];
            for (var atividade in builder.data!) {
              atividadesWidget.add(
                ItemAtividade(
                  atividade: atividade,
                  onTap: () {
                    Navigator.of(context).push(
                      AnimatedPageTransition(
                        page: AtividadeCadastro(
                          privilegio: widget.privilegio,
                          atividade: atividade,
                          opcao: global.opcaoAlteracao,
                        ),
                      ),
                    );
                    setState(() {});
                  },
                ),
              );
            }
            widget.edit
                ? atividadesWidget.add(
                    botaoAdicionarAtividade(),
                  )
                : Container();
            return AgrupadorCadastro(
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
              titulo: 'Atividades',
              children: atividadesWidget,
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }

  StreamBuilder<List<Medicamento>> medicamentoGroup() {
    return StreamBuilder(
        stream:
            firestorePaciente.todosMedicamentosPaciente(widget.paciente!.id),
        builder: (context, AsyncSnapshot<List<Medicamento>> builder) {
          if (builder.hasData) {
            medicamentosWidget = [];
            for (var medicamento in builder.data!) {
              medicamentosWidget.add(
                ItemMedicamento(
                  medicamento: medicamento,
                  onTap: () {
                    Navigator.of(context).push(
                      AnimatedPageTransition(
                        page: MedicamentoCadastro(
                          privilegio: widget.privilegio,
                          medicamento: medicamento,
                          opcao: global.opcaoAlteracao,
                        ),
                      ),
                    );
                    setState(() {});
                  },
                ),
              );
            }
            widget.edit
                ? medicamentosWidget.add(botaoAdicionarMedicamento())
                : Container();
            return AgrupadorCadastro(
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
              titulo: 'Medicamentos',
              children: medicamentosWidget,
            );
          } else {
            return Container();
          }
        });
  }

  Widget botaoAdicionarMedicamento() {
    return BotaoCadastro(
      onPressed: () async {
        await Navigator.of(context).push(
          AnimatedPageTransition(
            page: MedicamentoCadastro(
              edit: true,
              privilegio: widget.privilegio,
              opcao: global.opcaoInclusao,
            ),
          ),
        );
        setState(() {});
      },
    );
  }

  Widget botaoAdicionarConsulta() {
    return BotaoCadastro(
      onPressed: () async {
        await Navigator.of(context).push(
          AnimatedPageTransition(
            page: ConsultaCadastro(
              privilegio: widget.privilegio,
              opcao: global.opcaoInclusao,
            ),
          ),
        );
        setState(() {});
      },
    );
  }

  Widget botaoAdicionarAtividade() {
    return BotaoCadastro(
      onPressed: () async {
        await Navigator.of(context).push(
          AnimatedPageTransition(
            page: AtividadeCadastro(
              privilegio: widget.privilegio,
              opcao: global.opcaoInclusao,
            ),
          ),
        );
        setState(() {});
      },
    );
  }

  void addPaciente() {
    widget.paciente = Paciente(
      ativo: true,
      cpf: cpfController.text,
      nome: nomeController.text,
      nascimento: nascimentoController.text,
      id: widget.paciente != null ? widget.paciente!.id : '',
      idResponsavel: global.idResponsavelGlobal,
    );
    widget.paciente!.idResponsavel = global.idResponsavelGlobal;
    if (widget.opcao == global.opcaoInclusao &&
        widget.paciente!.nome.isNotEmpty &&
        widget.paciente!.id.isEmpty &&
        widget.paciente!.cpf.isNotEmpty) {
      firestorePaciente.incluirPaciente(widget.paciente!).then(
        (value) {
          setState(() {
            widget.paciente = value;
          });
        },
      );
    } else if (widget.opcao == global.opcaoAlteracao) {
      firestorePaciente.atualizarPaciente(widget.paciente!);
    }
  }

  void excluirPaciente() {
    firestorePaciente.excluirPaciente(widget.paciente!);
  }

  Widget tarefaGroup() {
    return StreamBuilder(
        stream: firestoreTarefa.getTarefasTodas(widget.paciente!.id),
        builder: (context, AsyncSnapshot<List<Tarefa>> builder) {
          if (builder.hasData) {
            tarefasWidget = [];
            for (var tarefa in builder.data!) {
              tarefasWidget.add(ItemTarefa(
                tarefa: tarefa,
              ));
            }
            return AgrupadorCadastro(
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
              titulo: 'Tarefas',
              children: tarefasWidget,
            );
          } else {
            return Container();
          }
        });
  }

  FutureBuilder<List<Cuidador>> cuidadorGroup() {
    return FutureBuilder(
        future: firestorePaciente.todosCuidadoresPaciente(widget.paciente!.id),
        builder: (context, AsyncSnapshot<List<Cuidador>> builder) {
          if (builder.hasData) {
            cuidadoresWidget = [];
            for (var cuidador in builder.data!) {
              cuidadoresWidget.add(ItemCuidador(
                privilegio: widget.privilegio,
                cuidador: cuidador,
              ));
            }
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
          } else {
            return Container();
          }
        });
  }
}
