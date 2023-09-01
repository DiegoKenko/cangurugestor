import 'package:cangurugestor/domain/entity/cuidador_entity.dart';
import 'package:cangurugestor/domain/entity/pessoa_entity.dart';
import 'package:cangurugestor/domain/entity/responsavel_entity.dart';

class GestorEntity extends PessoaEntity {
  List<CuidadorEntity> cuidadores = [];
  List<CuidadorEntity> cuidadoresDisponiveis = [];
  List<ResponsavelEntity> clientes = [];
  GestorEntity();

  GestorEntity.fromPessoa(PessoaEntity pessoa) {
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

  GestorEntity.fromMap(Map<String, dynamic> map) : super.fromMap(map) {
    cpf = map['cpf'];
    nome = map['nome'];
    sobrenome = map['sobrenome'];
    sexo = map['sexo'];
    email = map['email'];
    telefone = map['telefone'];
    nascimento = map['nascimento'];
    rua = map['rua'];
    numeroRua = map['numeroRua'];
    complementoRua = map['complementoRua'];
    bairro = map['bairro'];
    cidade = map['cidade'];
    cep = map['cep'];
    estado = map['estado'];
  }

  @override
  toMap() {
    return {
      'cpf': cpf,
      'nome': nome,
      'sobrenome': sobrenome,
      'sexo': sexo,
      'email': email,
      'telefone': telefone,
      'nascimento': nascimento,
      'rua': rua,
      'numeroRua': numeroRua,
      'complementoRua': complementoRua,
      'bairro': bairro,
      'cidade': cidade,
      'cep': cep,
      'estado': estado,
      'cuidadores': cuidadores.map((e) => e.id).toList(),
      'clientes': clientes.map((e) => e.id).toList(),
    };
  }
}
