import 'package:cangurugestor/model/pessoa.dart';

class Gestor extends Pessoa {
  List<String> idClientes = [];
  List<String> idCuidadores = [];
  Gestor();

  Gestor.fromMap(Map<String, dynamic> map) : super.fromMap(map) {
    cpf = map['cpf'];
    nome = map['nome'];
    sobrenome = map['sobrenome'];
    sexo = map['sexo'];
    idClientes = List<String>.from(map['idClientes']);
    idCuidadores = List<String>.from(map['idCuidadores']);
  }

  @override
  toMap() {
    return {
      'cpf': cpf,
      'nome': nome,
      'sobrenome': sobrenome,
      'sexo': sexo,
      'idClientes': idClientes,
      'idCuidadores': idCuidadores,
    };
  }
}
