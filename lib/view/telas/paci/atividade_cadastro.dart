import 'package:cangurugestor/model/tarefa.dart';
import 'package:cangurugestor/firebaseUtils/fire_atividade.dart';
import 'package:cangurugestor/firebaseUtils/fire_tarefa.dart';

import 'package:flutter/material.dart';

import 'package:cangurugestor/global.dart' as global;

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
      body: Container(),
    );
  }
}
