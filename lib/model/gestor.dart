import 'package:cangurugestor/model/cuidador.dart';
import 'package:cangurugestor/model/pessoa.dart';
import 'package:cangurugestor/model/responsavel.dart';

class Gestor extends Pessoa {
  List<Cuidador> cuidadores = [];
  List<Cuidador> cuidadoresDisponiveis = [];
  List<Responsavel> clientes = [];
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
    email = map['email'];
    /*   telefone = map['telefone'];
    nascimento = map['nascimento'];
    rua = map['rua'];
    numeroRua = map['numeroRua'];
    complementoRua = map['complementoRua'];
    bairro = map['bairro'];
    cidade = map['cidade'];
    cep = map['cep'];
    estado = map['estado']; */
  }

  @override
  toMap() {
    return {
      'cpf': cpf,
      'nome': nome,
      'sobrenome': sobrenome,
      'sexo': sexo,
      'email': email,
      /* 'telefone': telefone,
      'nascimento': nascimento,
      'rua': rua,
      'numeroRua': numeroRua,
      'complementoRua': complementoRua,
      'bairro': bairro,
      'cidade': cidade,
      'cep': cep,
      'estado': estado, */
    };
  }
}
