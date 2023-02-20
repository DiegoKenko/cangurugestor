import 'package:cangurugestor/model/cuidador.dart';
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
import 'package:cangurugestor/viewModel/provider_atividade.dart';
import 'package:cangurugestor/viewModel/provider_consulta.dart';
import 'package:cangurugestor/viewModel/provider_gestor.dart';
import 'package:cangurugestor/bloc/bloc_auth.dart';
import 'package:cangurugestor/viewModel/provider_medicamento.dart';
import 'package:cangurugestor/viewModel/provider_paciente.dart';
import 'package:cangurugestor/viewModel/provider_responsavel.dart';
import 'package:flutter/material.dart';
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
      if (context.read<PacienteProvider>().paciente.id.isEmpty) {
        if (context.read<AuthBloc>().state.login.editaPaciente) {
          context.read<PacienteProvider>().update().then((value) {
            context
                .read<ResponsavelProvider>()
                .addPaciente(context.read<PacienteProvider>().paciente);
          });
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
    final PacienteProvider pacienteProvider = context.watch<PacienteProvider>();
    final ResponsavelProvider responsavelProvider =
        context.watch<ResponsavelProvider>();
    pacienteProvider.responsavel = responsavelProvider.responsavel;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.read<AuthBloc>().state.login.editaPaciente) {
              context.read<PacienteProvider>().update().then(
                    (value) => context
                        .read<ResponsavelProvider>()
                        .addPaciente(context.read<PacienteProvider>().paciente),
                  );
            }
            pacienteProvider.clear();
            Navigator.of(context).pop();
          },
        ),
        actions: [
          context.read<AuthBloc>().state.login.editaPaciente
              ? IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    responsavelProvider
                        .removePaciente(pacienteProvider.paciente);
                    pacienteProvider.clear();
                    Navigator.of(context).pop();
                  },
                )
              : const SizedBox(),
        ],
        centerTitle: true,
        title: Column(
          children: [
            Text(
              pacienteProvider.paciente.nome.toUpperCase(),
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
    final GestorProvider gestorProvider = context.watch<GestorProvider>();
    final PacienteProvider pacienteProvider = context.watch<PacienteProvider>();
    return Builder(
      builder: (context) {
        pacienteProvider.loadCuidadores();
        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: pacienteProvider.cuidadores.length,
                itemBuilder: (context, index) {
                  return ItemContainer(
                    title: pacienteProvider.cuidadores[index].nome,
                    subtitle: pacienteProvider.cuidadores[index].sobrenome,
                  );
                },
              ),
            ),
            context.read<AuthBloc>().state.login.editaPaciente
                ? BotaoCadastro(
                    onPressed: () {
                      context
                          .read<GestorProvider>()
                          .todosCuidadoresDisponiveis();
                      showModalBottomSheet(
                        isScrollControlled: true,
                        isDismissible: false,
                        elevation: 10,
                        context: context,
                        builder: ((context) {
                          return SizedBox(
                            height: MediaQuery.of(context).size.height * 0.5,
                            child: Consumer<PacienteProvider>(
                              builder: (context, provider, _) {
                                return SingleChildScrollView(
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
                                      Column(
                                        children:
                                            gestorProvider.cuidadoresDisponiveis
                                                .map(
                                                  (Cuidador e) => ItemContainer(
                                                    onTap: () {},
                                                    title: e.nome,
                                                    trailing: provider.paciente
                                                            .idCuidadores
                                                            .contains(e.id)
                                                        ? ElevatedButton(
                                                            onPressed: () {
                                                              provider
                                                                  .removeCuidadorPaciente(
                                                                e,
                                                              );
                                                            },
                                                            child: const Text(
                                                              'Remover',
                                                            ),
                                                          )
                                                        : ElevatedButton(
                                                            onPressed: () {
                                                              provider
                                                                  .addCuidadorPaciente(
                                                                e,
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
                                    ],
                                  ),
                                );
                              },
                            ),
                          );
                        }),
                      );
                    },
                  )
                : Container(),
          ],
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
    final PacienteProvider pacienteProvider = context.watch<PacienteProvider>();
    return Column(
      children: [
        Expanded(
          child: Builder(
            builder: (context) {
              pacienteProvider.loadAtividades();
              if (pacienteProvider.paciente.atividades.isEmpty) {
                return const Center(
                  child: Text('Nenhuma atividade cadastrada'),
                );
              } else {
                return ListView.builder(
                  itemCount: pacienteProvider.paciente.atividades.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        context.read<AtividadeProvider>().atividade =
                            pacienteProvider.paciente.atividades[index];
                        Navigator.of(context).push(
                          AnimatedPageTransition(
                            page: const CadastroAtividade(),
                          ),
                        );
                      },
                      child: ItemContainer(
                        title: pacienteProvider
                            .paciente.atividades[index].descricao,
                        subtitle:
                            pacienteProvider.paciente.atividades[index].local,
                      ),
                    );
                  },
                );
              }
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
                          page: const CadastroAtividade(),
                        ),
                      );
                    },
                  ),
                ),
              )
            : Container(),
      ],
    );
  }
}

class ConsultasPaciente extends StatelessWidget {
  const ConsultasPaciente({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PacienteProvider pacienteProvider = context.watch<PacienteProvider>();
    return Column(
      children: [
        Expanded(
          child: Builder(
            builder: (context) {
              pacienteProvider.loadConsultas();
              if (pacienteProvider.paciente.consultas.isEmpty) {
                return const Center(
                  child: Text(
                    'Nenhuma consulta cadastrada',
                  ),
                );
              } else {
                return ListView.builder(
                  itemCount: pacienteProvider.paciente.consultas.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        context.read<ConsultaProvider>().consulta =
                            pacienteProvider.paciente.consultas[index];
                        Navigator.of(context).push(
                          AnimatedPageTransition(
                            page: const CadastroConsulta(),
                          ),
                        );
                      },
                      child: ItemContainer(
                        title: pacienteProvider
                            .paciente.consultas[index].descricao,
                      ),
                    );
                  },
                );
              }
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
                          page: const CadastroConsulta(),
                        ),
                      );
                    },
                  ),
                ),
              )
            : Container(),
      ],
    );
  }
}

class MedicamentosPaciente extends StatelessWidget {
  const MedicamentosPaciente({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PacienteProvider pacienteProvider = context.watch<PacienteProvider>();

    return Column(
      children: [
        Expanded(
          child: Builder(
            builder: (context) {
              pacienteProvider.loadMedicamentos();
              if (pacienteProvider.paciente.medicamentos.isEmpty) {
                return const Center(
                  child: Text('Nenhum medicamento cadastrado'),
                );
              }
              {
                return ListView.builder(
                  itemCount: pacienteProvider.paciente.medicamentos.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        context.read<MedicamentoProvider>().setMedicamento(
                              pacienteProvider.paciente.medicamentos[index],
                            );
                        Navigator.of(context).push(
                          AnimatedPageTransition(
                            page: const CadastroMedicamento(),
                          ),
                        );
                      },
                      child: ItemContainer(
                        title:
                            pacienteProvider.paciente.medicamentos[index].nome,
                      ),
                    );
                  },
                );
              }
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
                          page: const CadastroMedicamento(),
                        ),
                      );
                    },
                  ),
                ),
              )
            : Container(),
      ],
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
  final TextEditingController _complementoRuaController =
      TextEditingController();
  final TextEditingController _cidadeController = TextEditingController();
  final TextEditingController _estadoController = TextEditingController();

  @override
  void initState() {
    _cpfController.addListener(() {
      // Listener para atualizar o CPF do responsável
      context.read<PacienteProvider>().paciente.cpf = _cpfController.text;
    });
    _nomeController.addListener(() {
      // Listener para atualizar o nome do responsável
      context.read<PacienteProvider>().paciente.nome = _nomeController.text;
    });
    _nascimentoController.addListener(() {
      // Listener para atualizar a data de nascimento do responsável
      context.read<PacienteProvider>().paciente.nascimento =
          _nascimentoController.text;
    });
    _ruaController.addListener(() {
      // Listener para atualizar a rua do responsável
      context.read<PacienteProvider>().paciente.rua = _ruaController.text;
    });
    _bairroController.addListener(() {
      // Listener para atualizar o bairro do responsável
      context.read<PacienteProvider>().paciente.bairro = _bairroController.text;
    });
    _numeroRuaController.addListener(() {
      // Listener para atualizar o número da rua do responsável
      context.read<PacienteProvider>().paciente.numeroRua =
          _numeroRuaController.text;
    });
    _complementoRuaController.addListener(() {
      // Listener para atualizar o complemento da rua do responsável
      context.read<PacienteProvider>().paciente.complementoRua =
          _complementoRuaController.text;
    });
    _cidadeController.addListener(() {
      // Listener para atualizar a cidade do responsável
      context.read<PacienteProvider>().paciente.cidade = _cidadeController.text;
    });
    _estadoController.addListener(() {
      // Listener para atualizar o estado do responsável
      context.read<PacienteProvider>().paciente.estado = _estadoController.text;
    });
    _cepController.addListener(() {
      // Listener para atualizar o CEP do responsável
      context.read<PacienteProvider>().paciente.cep = _cepController.text;
      // Listener para atualizar os campos de endereço
      if (_cepController.text.length == 9) {
        CepAPI.getCep(_cepController.text).then((value) {
          if (value['cep'] != null) {
            _ruaController.text = value['logradouro'];
            _bairroController.text = value['bairro'];
            _cidadeController.text = value['localidade'];
            _estadoController.text = value['uf'];
            context.read<PacienteProvider>().paciente.rua = value['logradouro'];
            context.read<PacienteProvider>().paciente.bairro = value['bairro'];
            context.read<PacienteProvider>().paciente.cidade =
                value['localidade'];
            context.read<PacienteProvider>().paciente.estado = value['uf'];

            return;
          } else {
            _ruaController.text = '';
            _bairroController.text = '';
            _cidadeController.text = '';
            _estadoController.text = '';
          }
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _cpfController.dispose();
    _nomeController.dispose();
    _nascimentoController.dispose();
    _ruaController.dispose();
    _bairroController.dispose();
    _numeroRuaController.dispose();
    _complementoRuaController.dispose();
    _cidadeController.dispose();
    _estadoController.dispose();
    _cepController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final PacienteProvider pacienteProvider = context.watch<PacienteProvider>();
    _cpfController.text = pacienteProvider.paciente.cpf;
    _nomeController.text = pacienteProvider.paciente.nome;
    _nascimentoController.text = pacienteProvider.paciente.nascimento;
    _cepController.text = pacienteProvider.paciente.cep;
    _ruaController.text = pacienteProvider.paciente.rua;
    _bairroController.text = pacienteProvider.paciente.bairro;
    _numeroRuaController.text = pacienteProvider.paciente.numeroRua;
    _complementoRuaController.text = pacienteProvider.paciente.complementoRua;
    _cidadeController.text = pacienteProvider.paciente.cidade;
    _estadoController.text = pacienteProvider.paciente.estado;

    return SingleChildScrollView(
      child: Form(
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
            FormCadastro(
              obrigatorio: true,
              enabled: true,
              controller: _ruaController,
              labelText: 'Endereço',
              textInputType: TextInputType.text,
            ),
            FormCadastro(
              enabled: true,
              controller: _numeroRuaController,
              labelText: 'Complemento',
              textInputType: TextInputType.text,
            ),
            FormCadastro(
              obrigatorio: true,
              enabled: true,
              controller: _bairroController,
              labelText: 'Bairro',
              textInputType: TextInputType.text,
            ),
            FormCadastro(
              obrigatorio: true,
              enabled: true,
              controller: _cidadeController,
              labelText: 'Cidade',
              textInputType: TextInputType.text,
            ),
            FormCadastro(
              obrigatorio: true,
              enabled: true,
              controller: _estadoController,
              labelText: 'Estado',
              textInputType: TextInputType.text,
            ),
          ],
        ),
      ),
    );
  }
}
