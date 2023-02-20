import 'package:cangurugestor/model/pessoa.dart';

class Gestor extends Pessoa {
  List<String> idClientes = [];
  List<String> idCuidadores = [];
  Gestor();

  Gestor.fromPessoa(Pessoa pessoa) {
    id = pessoa.id;
    nome = pessoa.nome;
    ativo = pessoa.ativo;
    email = pessoa.email;
    telefone = pessoa.telefone;
    nascimento = pessoa.nascimento;
    rua = pessoa.rua;
    numeroRua = pessoa.numeroRua;
    complementoRua = pessoa.complementoRua;
    bairro = pessoa.bairro;
    cidade = pessoa.cidade;
    cep = pessoa.cep;
    estado = pessoa.estado;
  }

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
