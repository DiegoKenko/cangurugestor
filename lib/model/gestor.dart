import 'package:cangurugestor/model/pessoa.dart';
import 'package:cangurugestor/model/responsavel.dart';

class Gestor extends Pessoa {
  String id = '';
  List<Responsavel> clientes = [];
  List<String> idClientes = [];

  Gestor();

  Gestor.fromMap(Map<String, dynamic> map) : super.fromMap(map) {
    cpf = map['cpf'];
    nome = map['nome'];
    sobrenome = map['sobrenome'];
    sexo = map['sexo'];
    idClientes = List<String>.from(map['idClientes']);
  }

  set newId(String id) => this.id = id;
}
