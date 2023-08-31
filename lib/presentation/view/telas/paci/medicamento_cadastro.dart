import 'package:cangurugestor/const/enum/enum_intervalo.dart';
import 'package:cangurugestor/domain/entity/medicamento_entity.dart';
import 'package:cangurugestor/domain/entity/tarefa_entity.dart';
import 'package:cangurugestor/presentation/state/medicamento_state.dart';
import 'package:cangurugestor/presentation/state/paciente_tarefas_state.dart';
import 'package:cangurugestor/presentation/view/componentes/adicionar_botao_rpc.dart';
import 'package:cangurugestor/presentation/view/componentes/dialog_confirmacao_exclusao.dart';
import 'package:cangurugestor/presentation/view/componentes/form_cadastro.dart';
import 'package:cangurugestor/presentation/view/componentes/form_cadastro_data.dart';
import 'package:cangurugestor/presentation/view/componentes/form_dropdown.dart';
import 'package:cangurugestor/presentation/view/componentes/item_container_tarefa.dart';
import 'package:cangurugestor/presentation/view/componentes/popup_tarefa.dart';
import 'package:cangurugestor/presentation/view/componentes/styles.dart';
import 'package:cangurugestor/presentation/view/componentes/tab.dart';
import 'package:cangurugestor/presentation/controller/medicamento_controller.dart';
import 'package:cangurugestor/presentation/controller/paciente_tarefas_controller.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// ignore: unnecessary_import

class CadastroMedicamento extends StatefulWidget {
  const CadastroMedicamento({
    Key? key,
  }) : super(key: key);

  @override
  State<CadastroMedicamento> createState() => _CadastroMedicamentoState();
}

class _CadastroMedicamentoState extends State<CadastroMedicamento>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {});
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return DialogConfirmacaoExclusao(
                    onConfirm: () {},
                  );
                },
              );
            },
          ),
        ],
        centerTitle: true,
        title: Column(
          children: [
            Text(
              '',
              style: kTitleAppBarStyle,
            ),
            Text(
              'medicamento',
              style: kSubtitleAppBarStyle,
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 30, bottom: 30),
          child: TabCanguru(
            controller: _tabController,
            tabs: const [
              Tab(
                text: 'Dados',
              ),
              Tab(
                text: 'Tarefas',
              ),
            ],
            views: const [
              Tab(
                child: DadosMedicamento(),
              ),
              Tab(
                child: TarefasMedicamento(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TarefasMedicamento extends StatefulWidget {
  const TarefasMedicamento({
    Key? key,
  }) : super(key: key);

  @override
  State<TarefasMedicamento> createState() => _TarefasMedicamentoState();
}

class _TarefasMedicamentoState extends State<TarefasMedicamento> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
        child: ValueListenableBuilder(
          valueListenable: PacienteTarefasController(),
          builder: (context, tarefasState, _) {
            var widgetTarefaSalvas = [];
            if (tarefasState is ListaTarefasSuccessState) {
              tarefasState.tarefas
                  .map(
                    (TarefaEntity tarefa) => ItemContainerTarefa(
                      tarefa: tarefa,
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => PopUpTarefa(
                            tarefa: tarefa,
                          ),
                        ).then((value) {
                          setState(() {});
                        });
                      },
                    ),
                  )
                  .toList();
            }

            return Column(
              children: [
                ...widgetTarefaSalvas,
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: BotaoCadastro(
                    onPressed: () {},
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class DadosMedicamento extends StatefulWidget {
  const DadosMedicamento({
    Key? key,
  }) : super(key: key);

  @override
  State<DadosMedicamento> createState() => _DadosMedicamentoState();
}

class _DadosMedicamentoState extends State<DadosMedicamento> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _doseController = TextEditingController();
  final TextEditingController _intervaloQtdeController =
      TextEditingController();
  final TextEditingController _intervaloUMController = TextEditingController();
  final TextEditingController _inicioController = TextEditingController();
  final TextEditingController _observacaoController = TextEditingController();

  @override
  void initState() {
    _nomeController.addListener(() {});
    _doseController.addListener(() {});
    _intervaloQtdeController.addListener(() {});
    _intervaloUMController.addListener(() {});
    _inicioController.addListener(() {});
    _observacaoController.addListener(() {});
    super.initState();
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _doseController.dispose();
    _intervaloQtdeController.dispose();
    _intervaloUMController.dispose();
    _inicioController.dispose();
    _observacaoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: MedicamentoController(),
      builder: (context, state, _) {
        MedicamentoEntity medicamento = MedicamentoEntity();
        if (state is MedicamentoSuccessState) {
          medicamento = state.medicamento;
          _nomeController.text = state.medicamento.nome;
          _doseController.text = state.medicamento.dose.toString();
          _intervaloQtdeController.text =
              state.medicamento.intervaloQuantidade.toString();
          _intervaloUMController.text = state.medicamento.intervalo.name.isEmpty
              ? EnumIntervalo.minutos.name
              : state.medicamento.intervalo.name;
          _inicioController.text = DateFormat('dd/MM/yyyy').format(
            state.medicamento.dataInicio == null
                ? DateTime.now()
                : state.medicamento.dataInicio!,
          );
          _observacaoController.text = state.medicamento.observacao;
        }
        return SingleChildScrollView(
          child: Column(
            children: [
              FormCadastro(
                obrigatorio: true,
                textInputType: TextInputType.name,
                enabled: true,
                controller: _nomeController,
                labelText: 'Nome',
              ),
              FormCadastro(
                obrigatorio: true,
                textInputType: TextInputType.number,
                enabled: true,
                controller: _doseController,
                labelText: 'Dose',
              ),
              Row(
                children: [
                  Expanded(
                    child: FormCadastro(
                      obrigatorio: true,
                      textInputType: TextInputType.number,
                      enabled: true,
                      controller: _intervaloQtdeController,
                      labelText: 'a cada:',
                    ),
                  ),
                  Expanded(
                    child: FormDropDown(
                      lista: EnumIntervalo.values
                          .map((e) => e.name)
                          .toList(growable: false),
                      controller: _intervaloUMController,
                      value: medicamento.intervalo.name,
                      hintText: 'Intervalo',
                    ),
                  ),
                ],
              ),
              FormCadastroData(
                dataInicial: DateTime.now(),
                dataUltima: DateTime(DateTime.now().year + 50),
                dataPrimeira: DateTime.now(),
                enabled: true,
                controller: _inicioController,
                labelText: 'Data de Início',
              ),
              FormCadastro(
                obrigatorio: true,
                textInputType: TextInputType.name,
                enabled: true,
                multiLine: true,
                controller: _observacaoController,
                labelText: 'Observação',
              ),
            ],
          ),
        );
      },
    );
  }
}
