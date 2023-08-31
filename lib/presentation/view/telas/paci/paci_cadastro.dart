import 'package:cangurugestor/domain/entity/atividade_entity.dart';
import 'package:cangurugestor/domain/entity/consulta_entity.dart';
import 'package:cangurugestor/domain/entity/cuidador_entity.dart';
import 'package:cangurugestor/domain/entity/medicamento_entity.dart';
import 'package:cangurugestor/presentation/state/gestor_state.dart';
import 'package:cangurugestor/presentation/state/paciente_state.dart';
import 'package:cangurugestor/presentation/utils/cep_api.dart';
import 'package:cangurugestor/presentation/view/componentes/adicionar_botao_rpc.dart';
import 'package:cangurugestor/presentation/view/componentes/animated_page_transition.dart';
import 'package:cangurugestor/presentation/view/componentes/dialog_confirmacao_exclusao.dart';
import 'package:cangurugestor/presentation/view/componentes/form_cadastro.dart';
import 'package:cangurugestor/presentation/view/componentes/form_cadastro_data.dart';
import 'package:cangurugestor/presentation/view/componentes/item_container.dart';
import 'package:cangurugestor/presentation/view/componentes/styles.dart';
import 'package:cangurugestor/presentation/view/componentes/tab.dart';
import 'package:cangurugestor/presentation/view/telas/paci/atividade_cadastro.dart';
import 'package:cangurugestor/presentation/view/telas/paci/consulta_cadastro.dart';
import 'package:cangurugestor/presentation/view/telas/paci/medicamento_cadastro.dart';
import 'package:cangurugestor/presentation/controller/gestor_controller.dart';
import 'package:cangurugestor/presentation/controller/paciente_controller.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class CadastroPaciente extends StatefulWidget {
  const CadastroPaciente({
    Key? key,
  }) : super(key: key);

  @override
  State<CadastroPaciente> createState() => _CadastroPacienteState();
}

class _CadastroPacienteState extends State<CadastroPaciente>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this, initialIndex: 0);
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
            Navigator.of(context).pop();
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
              'paciente',
              style: kSubtitleAppBarStyle,
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: TabCanguru(
          tabs: const [
            Tab(
              text: 'Dados',
            ),
            Tab(
              text: 'Ficha',
            ),
            Tab(
              text: 'Cuidadores',
            ),
          ],
          views: const [
            Tab(
              child: DadosPaciente(),
            ),
            Tab(
              child: FichaPaciente(),
            ),
            Tab(
              child: CuidadoresPaciente(),
            ),
          ],
          controller: _tabController,
        ),
      ),
    );
  }
}

class CuidadoresPaciente extends StatefulWidget {
  const CuidadoresPaciente({
    Key? key,
  }) : super(key: key);

  @override
  State<CuidadoresPaciente> createState() => _CuidadoresPacienteState();
}

class _CuidadoresPacienteState extends State<CuidadoresPaciente> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: PacienteController(),
      builder: (context, pacienteState, _) {
        if (pacienteState is PacienteSuccessState) {
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: pacienteState.paciente.cuidadores.length,
                  itemBuilder: (context, index) {
                    return ItemContainer(
                      title: pacienteState.paciente.cuidadores[index].nome,
                      subtitle:
                          pacienteState.paciente.cuidadores[index].sobrenome,
                    );
                  },
                ),
              ),
              const BotaoAddCuidador(),
            ],
          );
        }
        return Container();
      },
    );
  }
}

class BotaoAddCuidador extends StatelessWidget {
  const BotaoAddCuidador({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BotaoCadastro(
      onPressed: () {
        showModalBottomSheet(
          isScrollControlled: true,
          isDismissible: false,
          elevation: 10,
          context: context,
          builder: ((context) {
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      color: corPad1,
                      height: 40,
                      width: double.infinity,
                      child: Center(
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.arrow_back,
                                color: corBranco,
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            const Expanded(
                              child: Center(
                                child: Text(
                                  'Cuidadores disponíveis',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    ValueListenableBuilder(
                      valueListenable: GestorController(),
                      builder: (context, gestorState, _) {
                        if (gestorState is GestorSuccessState) {
                          return ValueListenableBuilder(
                            valueListenable: PacienteController(),
                            builder: (context, pacienteState, _) {
                              if (pacienteState is PacienteSuccessState) {
                                return Column(
                                  children: gestorState.gestor.cuidadores
                                      .map(
                                        (CuidadorEntity e) => ItemContainer(
                                          onTap: () {},
                                          title: e.nome,
                                          trailing: pacienteState
                                                  .paciente.idCuidadores
                                                  .contains(e.id)
                                              ? ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text(
                                                    'Remover',
                                                  ),
                                                )
                                              : ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child:
                                                      const Text('Adicionar'),
                                                ),
                                        ),
                                      )
                                      .toList(),
                                );
                              }
                              return Container();
                            },
                          );
                        }
                        return Container();
                      },
                    ),
                  ],
                ),
              ),
            );
          }),
        );
      },
    );
  }
}

class FichaPaciente extends StatefulWidget {
  const FichaPaciente({
    Key? key,
  }) : super(key: key);

  @override
  State<FichaPaciente> createState() => _FichaPacienteState();
}

class _FichaPacienteState extends State<FichaPaciente>
    with SingleTickerProviderStateMixin {
  late TabController _tabControllerTarefa;

  @override
  void initState() {
    _tabControllerTarefa = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TabCanguru(
      direction: VerticalDirection.up,
      controller: _tabControllerTarefa,
      tabs: const [
        Tab(
          child: Column(
            children: [kIconMedicamento, Text('Medicação')],
          ),
        ),
        Tab(
          child: Column(
            children: [kIconConsulta, Text('Consultas')],
          ),
        ),
        Tab(
          child: Column(
            children: [kIconAtividade, Text('Atividades')],
          ),
        ),
      ],
      views: const [
        Tab(
          child: MedicamentosPaciente(),
        ),
        Tab(
          child: ConsultasPaciente(),
        ),
        Tab(
          child: AtividadesPaciente(),
        ),
      ],
    );
  }
}

class AtividadesPaciente extends StatelessWidget {
  const AtividadesPaciente({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: PacienteController(),
      builder: (context, state, _) {
        if (state is PacienteSuccessState) {
          return Column(
            children: [
              Expanded(
                child: state.paciente.atividades.isEmpty
                    ? const Center(
                        child: Text('Nenhuma atividade cadastrada'),
                      )
                    : ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: state.paciente.atividades.length,
                        itemBuilder: (context, index) {
                          AtividadeEntity atividade =
                              state.paciente.atividades[index];
                          atividade.paciente = state.paciente;
                          return InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                AnimatedPageTransition(
                                  page: const CadastroAtividade(),
                                ),
                              );
                            },
                            child: ItemContainer(
                              title: atividade.descricao,
                              subtitle: atividade.local,
                            ),
                          );
                        },
                      ),
              ),
              SizedBox(
                height: 40,
                child: Center(
                  child: BotaoCadastro(
                    onPressed: () {
                      Navigator.of(context).push(
                        AnimatedPageTransition(
                          page: const CadastroAtividade(),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        }
        return Container();
      },
    );
  }
}

class ConsultasPaciente extends StatelessWidget {
  const ConsultasPaciente({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: PacienteController(),
      builder: (context, state, _) {
        if (state is PacienteSuccessState) {
          return Column(
            children: [
              Expanded(
                child: state.paciente.consultas.isEmpty
                    ? const Center(
                        child: Text(
                          'Nenhuma consulta cadastrada',
                        ),
                      )
                    : ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: state.paciente.consultas.length,
                        itemBuilder: (context, index) {
                          ConsultaEntity consulta =
                              state.paciente.consultas[index];
                          consulta.paciente = state.paciente;
                          return InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                AnimatedPageTransition(
                                  page: const CadastroConsulta(),
                                ),
                              );
                            },
                            child: ItemContainer(
                              title: consulta.descricao,
                              subtitle: consulta.medico,
                            ),
                          );
                        },
                      ),
              ),
              SizedBox(
                height: 40,
                child: Center(
                  child: BotaoCadastro(
                    onPressed: () {
                      Navigator.of(context).push(
                        AnimatedPageTransition(
                          page: const CadastroConsulta(),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        }
        return Container();
      },
    );
  }
}

class MedicamentosPaciente extends StatelessWidget {
  const MedicamentosPaciente({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: PacienteController(),
      builder: (context, state, _) {
        if (state is PacienteSuccessState) {
          return Column(
            children: [
              Expanded(
                child: state.paciente.medicamentos.isEmpty
                    ? const Center(
                        child: Text('Nenhum medicamento cadastrado'),
                      )
                    : ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: state.paciente.medicamentos.length,
                        itemBuilder: (context, index) {
                          MedicamentoEntity medicamento =
                              state.paciente.medicamentos[index];
                          medicamento.paciente = state.paciente;
                          return InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                AnimatedPageTransition(
                                  page: const CadastroMedicamento(),
                                ),
                              );
                            },
                            child: ItemContainer(
                              title: medicamento.nome,
                              subtitle: medicamento.observacao,
                            ),
                          );
                        },
                      ),
              ),
              SizedBox(
                height: 40,
                child: Center(
                  child: BotaoCadastro(
                    onPressed: () {
                      Navigator.of(context).push(
                        AnimatedPageTransition(
                          page: const CadastroMedicamento(),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        }
        return Container();
      },
    );
  }
}

class DadosPaciente extends StatefulWidget {
  const DadosPaciente({
    Key? key,
  }) : super(key: key);

  @override
  State<DadosPaciente> createState() => _DadosPacienteState();
}

class _DadosPacienteState extends State<DadosPaciente> {
  final TextEditingController _cpfController = TextEditingController();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _nascimentoController = TextEditingController();
  final TextEditingController _cepController = TextEditingController();
  final TextEditingController _ruaController = TextEditingController();
  final TextEditingController _bairroController = TextEditingController();
  final TextEditingController _numeroRuaController = TextEditingController();

  final TextEditingController _cidadeController = TextEditingController();
  final TextEditingController _estadoController = TextEditingController();

  @override
  void initState() {
    _cpfController.addListener(() {});
    _nomeController.addListener(() {});
    _nascimentoController.addListener(() {});
    _numeroRuaController.addListener(() {});
    _cepController.addListener(() async {});
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _cpfController.dispose();
    _nomeController.dispose();
    _nascimentoController.dispose();
    _ruaController.dispose();
    _bairroController.dispose();
    _numeroRuaController.dispose();
    _cidadeController.dispose();
    _estadoController.dispose();
    _cepController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ValueListenableBuilder(
        valueListenable: PacienteController(),
        builder: (context, state, _) {
          if (state is PacienteSuccessState) {
            _cpfController.text = state.paciente.cpf;
            _nomeController.text = state.paciente.nome;
            _nascimentoController.text = state.paciente.nascimento;
            _cepController.text = state.paciente.cep;
            _ruaController.text = state.paciente.rua;
            _bairroController.text = state.paciente.bairro;
            _numeroRuaController.text = state.paciente.numeroRua;
            _cidadeController.text = state.paciente.cidade;
            _estadoController.text = state.paciente.estado;
          }
          return Form(
            child: Column(
              children: [
                FormCadastro(
                  obrigatorio: true,
                  enabled: true,
                  controller: _cpfController,
                  labelText: 'CPF',
                  inputFormatters: [
                    MaskTextInputFormatter(
                      mask: '###.###.###-##',
                      filter: {'#': RegExp(r'[0-9]')},
                    ),
                  ],
                  textInputType: TextInputType.phone,
                ),
                FormCadastro(
                  obrigatorio: true,
                  enabled: true,
                  controller: _nomeController,
                  labelText: 'Nome',
                  textInputType: TextInputType.text,
                ),
                FormCadastroData(
                  obrigatorio: true,
                  enabled: true,
                  dataPrimeira: DateTime(DateTime.now().year - 100),
                  dataInicial: DateTime(DateTime.now().year - 10),
                  dataUltima: DateTime(DateTime.now().year),
                  controller: _nascimentoController,
                  labelText: 'Data de nascimento',
                ),
                FormCadastro(
                  enabled: true,
                  controller: _cepController,
                  labelText: 'CEP',
                  hintText: '000000-000',
                  inputFormatters: [
                    MaskTextInputFormatter(
                      mask: '#####-###',
                      filter: {'#': RegExp(r'[0-9]')},
                    ),
                  ],
                  textInputType: TextInputType.text,
                ),
                FutureBuilder(
                  future: _cepController.text.isEmpty
                      ? Future.delayed(
                          const Duration(seconds: 1),
                        )
                      : CepAPI.getCep(_cepController.text),
                  builder: (context, snap) {
                    if (snap.hasData) {
                      _ruaController.text = snap.data['logradouro'];
                      _bairroController.text = snap.data['bairro'];
                      _cidadeController.text = snap.data['localidade'];
                      _estadoController.text = snap.data['uf'];
                    }
                    return Column(
                      children: [
                        FormCadastro(
                          controller: _ruaController,
                          labelText: 'Endereço',
                          textInputType: TextInputType.text,
                        ),
                        FormCadastro(
                          enabled: true,
                          controller: _numeroRuaController,
                          labelText: 'Número/complemento',
                          textInputType: TextInputType.text,
                        ),
                        FormCadastro(
                          controller: _bairroController,
                          labelText: 'Bairro',
                          textInputType: TextInputType.text,
                        ),
                        FormCadastro(
                          controller: _cidadeController,
                          labelText: 'Cidade',
                          textInputType: TextInputType.text,
                        ),
                        FormCadastro(
                          controller: _estadoController,
                          labelText: 'Estado',
                          textInputType: TextInputType.text,
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
