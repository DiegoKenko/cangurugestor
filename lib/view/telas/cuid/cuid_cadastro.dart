import 'package:cangurugestor/firebaseUtils/fire_cuidador.dart';
import 'package:cangurugestor/firebaseUtils/fire_responsavel.dart';
import 'package:cangurugestor/utils/cep_api.dart';
import 'package:flutter/material.dart';

class CadastroCuidador extends StatefulWidget {
  const CadastroCuidador({
    Key? key,
  }) : super(key: key);

  @override
  State<CadastroCuidador> createState() => _CadastroCuidadorState();
}

class _CadastroCuidadorState extends State<CadastroCuidador> {
  var cpfController = TextEditingController();
  var nomeController = TextEditingController();
  var nascimentoController = TextEditingController();
  var emailController = TextEditingController();
  var telefoneController = TextEditingController();
  var senhaController = TextEditingController();
  var cepController = TextEditingController();
  var ruaController = TextEditingController();
  var bairroController = TextEditingController();
  var numeroRuaController = TextEditingController();
  var complementoRuaController = TextEditingController();
  var cidadeController = TextEditingController();
  var estadoController = TextEditingController();
  bool ativo = true;
  List<Widget> pacientesWidget = [];
  final FirestoreResponsavel firestoreResponsavel = FirestoreResponsavel();
  final FirestoreCuidador firestoreCuidador = FirestoreCuidador();

  @override
  void initState() {
    cepController.addListener(() {
      // Listener para atualizar os campos de endereço
      if (cepController.text.length == 9) {
        CepAPI.getCep(cepController.text).then((value) {
          if (value['cep'] != null) {
            ruaController.text = value['logradouro'];
            bairroController.text = value['bairro'];
            cidadeController.text = value['localidade'];
            estadoController.text = value['uf'];
            return;
          } else {
            ruaController.text = '';
            bairroController.text = '';
            cidadeController.text = '';
            estadoController.text = '';
          }
        });
      }
    });
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
      appBar: AppBar(),
      body: Container(),
    );
  }
}
