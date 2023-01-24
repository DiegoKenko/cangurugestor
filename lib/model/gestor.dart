import 'package:cangurugestor/model/login_user.dart';
import 'package:cangurugestor/model/pessoa.dart';

class Gestor extends Pessoa with LoginUser {
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
