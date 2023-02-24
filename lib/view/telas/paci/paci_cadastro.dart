import 'package:cangurugestor/model/atividade.dart';
import 'package:cangurugestor/model/consulta.dart';
import 'package:cangurugestor/model/cuidador.dart';
import 'package:cangurugestor/model/medicamento.dart';
import 'package:cangurugestor/model/paciente.dart';
import 'package:cangurugestor/utils/cep_api.dart';
import 'package:cangurugestor/view/componentes/adicionar_botao_rpc.dart';
import 'package:cangurugestor/view/componentes/animated_page_transition.dart';
import 'package:cangurugestor/view/componentes/form_cadastro.dart';
import 'package:cangurugestor/view/componentes/form_cadastro_data.dart';
import 'package:cangurugestor/view/componentes/item_container.dart';
import 'package:cangurugestor/view/componentes/styles.dart';
import 'package:cangurugestor/view/componentes/tab.dart';
import 'package:cangurugestor/view/telas/paci/atividade_cadastro.dart';
import 'package:cangurugestor/view/telas/paci/consulta_cadastro.dart';
import 'package:cangurugestor/view/telas/paci/medicamento_cadastro.dart';
import 'package:cangurugestor/viewModel/bloc_atividade.dart';
import 'package:cangurugestor/viewModel/bloc_consulta.dart';
import 'package:cangurugestor/bloc/bloc_auth.dart';
import 'package:cangurugestor/viewModel/bloc_gestor.dart';
import 'package:cangurugestor/viewModel/bloc_medicamento.dart';
import 'package:cangurugestor/viewModel/bloc_paciente.dart';
import 'package:cangurugestor/viewModel/bloc_responsavel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';

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
    _tabController.addListener(() {
      if (context.read<PacienteBloc>().state.paciente.id.isEmpty) {
        if (context.read<AuthBloc>().state.login.editaPaciente) {
          context.read<PacienteBloc>().add(PacienteUpdateEvent());
        }
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PacienteBloc, PacienteState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                if (context.read<AuthBloc>().state.login.editaPaciente) {
                  context.read<PacienteBloc>().add(PacienteUpdateEvent());
                }
                Navigator.of(context).pop();
              },
            ),
            actions: [
              context.read<AuthBloc>().state.login.editaPaciente
                  ? IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        context.read<PacienteBloc>().add(PacienteDeleteEvent());
                        Navigator.of(context).pop();
                      },
                    )
                  : const SizedBox(),
            ],
            centerTitle: true,
            title: Column(
              children: [
                Text(
                  state.paciente.nome.toUpperCase(),
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
      },
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
    return BlocBuilder<PacienteBloc, PacienteState>(
      builder: (context, pacienteState) {
        context.read<PacienteBloc>().add(PacienteLoadCuidadoresEvent());
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
            context.read<AuthBloc>().state.login.editaPaciente
                ? const BotaoAddCuidador()
                : Container(),
          ],
        );
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
                    BlocProvider.value(
                      value: context.read<PacienteBloc>(),
                      child: BlocProvider.value(
                        value: context.read<GestorBloc>(),
                        child: Column(
                          children: context
                              .read<GestorBloc>()
                              .state
                              .gestor
                              .cuidadoresDisponiveis
                              .map(
                                (Cuidador e) => ItemContainer(
                                  onTap: () {},
                                  title: e.nome,
                                  trailing: context
                                          .read<PacienteBloc>()
                                          .state
                                          .paciente
                                          .idCuidadores
                                          .contains(e.id)
                                      ? ElevatedButton(
                                          onPressed: () {
                                            context.read<PacienteBloc>().add(
                                                  PacienteRemoveCuidadorEvent(
                                                    e,
                                                  ),
                                                );
                                          },
                                          child: const Text(
                                            'Remover',
                                          ),
                                        )
                                      : ElevatedButton(
                                          onPressed: () {
                                            context.read<PacienteBloc>().add(
                                                  PacienteAddCuidadorEvent(
                                                    e,
                                                  ),
                                                );
                                          },
                                          child: const Text(
                                            'Adicionar',
                                          ),
                                        ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
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
      tabs: [
        Tab(
          child: Column(
            children: const [
              kIconMedicamento,
              Text(
                'Medicamentos',
              )
            ],
          ),
        ),
        Tab(
          child: Column(
            children: const [
              kIconConsulta,
              Text(
                'Consultas',
              )
            ],
          ),
        ),
        Tab(
          child: Column(
            children: const [
              kIconAtividade,
              Text(
                'Atividades',
              )
            ],
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
    return BlocBuilder<PacienteBloc, PacienteState>(
      builder: (context, state) {
        context.read<PacienteBloc>().add(PacienteLoadAtividadesEvent());
        return Column(
          children: [
            Expanded(
              child: state.paciente.atividades.isEmpty
                  ? const Center(
                      child: Text('Nenhuma atividade cadastrada'),
                    )
                  : ListView.builder(
                      itemCount: state.paciente.atividades.length,
                      itemBuilder: (context, index) {
                        Atividade atividade = state.paciente.atividades[index];
                        atividade.paciente = state.paciente;
                        return InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              AnimatedPageTransition(
                                page: BlocProvider<AtividadeBloc>(
                                  create: (context) => AtividadeBloc(atividade),
                                  child: const CadastroAtividade(),
                                ),
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
            context.read<AuthBloc>().state.login.editaPaciente
                ? SizedBox(
                    height: 40,
                    child: Center(
                      child: BotaoCadastro(
                        onPressed: () {
                          Navigator.of(context).push(
                            AnimatedPageTransition(
                              page: BlocProvider<AtividadeBloc>(
                                create: (context) => AtividadeBloc(
                                    Atividade.initOnAdd(state.paciente)),
                                child: const CadastroAtividade(),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  )
                : Container(),
          ],
        );
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
    return BlocBuilder<PacienteBloc, PacienteState>(
      builder: (context, state) {
        context.read<PacienteBloc>().add(PacienteLoadConsultasEvent());
        return Column(
          children: [
            Expanded(
              child: state.paciente.consultas.isEmpty
                  ? const Center(
                      child: Text(
                      'Nenhuma consulta cadastrada',
                    ))
                  : ListView.builder(
                      itemCount: state.paciente.consultas.length,
                      itemBuilder: (context, index) {
                        Consulta consulta = state.paciente.consultas[index];
                        consulta.paciente = state.paciente;
                        return InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              AnimatedPageTransition(
                                page: BlocProvider<ConsultaBloc>(
                                  create: (context) => ConsultaBloc(consulta),
                                  child: const CadastroConsulta(),
                                ),
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
            context.read<AuthBloc>().state.login.editaPaciente
                ? SizedBox(
                    height: 40,
                    child: Center(
                      child: BotaoCadastro(
                        onPressed: () {
                          Navigator.of(context).push(
                            AnimatedPageTransition(
                              page: BlocProvider<ConsultaBloc>(
                                create: (context) => ConsultaBloc(
                                    Consulta.initOnAdd(state.paciente)),
                                child: const CadastroConsulta(),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  )
                : Container(),
          ],
        );
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
    return BlocBuilder<PacienteBloc, PacienteState>(
      builder: (context, state) {
        context.read<PacienteBloc>().add(PacienteLoadMedicamentosEvent());
        return Column(
          children: [
            Expanded(
              child: state.paciente.medicamentos.isEmpty
                  ? const Center(
                      child: Text('Nenhum medicamento cadastrado'),
                    )
                  : ListView.builder(
                      itemCount: state.paciente.medicamentos.length,
                      itemBuilder: (context, index) {
                        Medicamento medicamento =
                            state.paciente.medicamentos[index];
                        medicamento.paciente = state.paciente;
                        return InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              AnimatedPageTransition(
                                page: BlocProvider<MedicamentoBloc>(
                                  create: (context) =>
                                      MedicamentoBloc(medicamento),
                                  child: const CadastroMedicamento(),
                                ),
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
            context.read<AuthBloc>().state.login.editaPaciente
                ? SizedBox(
                    height: 40,
                    child: Center(
                      child: BotaoCadastro(
                        onPressed: () {
                          Navigator.of(context).push(
                            AnimatedPageTransition(
                              page: BlocProvider<MedicamentoBloc>(
                                create: (context) => MedicamentoBloc(
                                  Medicamento.initOnAdd(state.paciente),
                                ),
                                child: const CadastroMedicamento(),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  )
                : Container(),
          ],
        );
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
    _cpfController.addListener(() {
      // Listener para atualizar o CPF do responsável
      context.read<PacienteBloc>().state.paciente.cpf = _cpfController.text;
    });
    _nomeController.addListener(() {
      // Listener para atualizar o nome do responsável
      context.read<PacienteBloc>().state.paciente.nome = _nomeController.text;
    });
    _nascimentoController.addListener(() {
      // Listener para atualizar a data de nascimento do responsável
      context.read<PacienteBloc>().state.paciente.nascimento =
          _nascimentoController.text;
    });

    _numeroRuaController.addListener(() {
      // Listener para atualizar o número da rua do responsável
      context.read<PacienteBloc>().state.paciente.numeroRua =
          _numeroRuaController.text;
    });

    _cepController.addListener(() async {
      // Listener para atualizar o CEP do responsável
      context.read<PacienteBloc>().state.paciente.cep = _cepController.text;
      // Listener para atualizar os campos de endereço
      if (_cepController.text.length == 9) {
        Map<dynamic, dynamic> value = await CepAPI.getCep(_cepController.text);
        if (value['cep'] != null) {
          _ruaController.text = value['logradouro'];
          _bairroController.text = value['bairro'];
          _cidadeController.text = value['localidade'];
          _estadoController.text = value['uf'];
          return;
        } else {
          _ruaController.text = '';
          _bairroController.text = '';
          _cidadeController.text = '';
          _estadoController.text = '';
        }
      }
    });
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
      child: BlocBuilder<PacienteBloc, PacienteState>(
        builder: (context, state) {
          _cpfController.text = state.paciente.cpf;
          _nomeController.text = state.paciente.nome;
          _nascimentoController.text = state.paciente.nascimento;
          _cepController.text = state.paciente.cep;
          _ruaController.text = state.paciente.rua;
          _bairroController.text = state.paciente.bairro;
          _numeroRuaController.text = state.paciente.numeroRua;
          _cidadeController.text = state.paciente.cidade;
          _estadoController.text = state.paciente.estado;
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
                    )
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
                    )
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
