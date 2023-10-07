import 'package:intl/intl.dart';

abstract class PessoaEntity {
  String id = '';
  String nome = '';
  String sobrenome = '';
  String nascimento = '';
  String sexo = '';
  String cpf = '';
  String rg = '';
  String email = '';
  String telefone = '';
  String celular = '';
  String rua = '';
  String numeroRua = '';
  String complementoRua = '';
  String bairro = '';
  String cidade = '';
  String estado = '';
  String cep = '';
  bool ativo = false;

  PessoaEntity({
    this.id = '',
    this.ativo = false,
    this.nome = '',
    this.sobrenome = '',
    this.nascimento = '',
    this.sexo = '',
    this.cpf = '',
    this.rg = '',
    this.email = '',
    this.telefone = '',
    this.celular = '',
    this.rua = '',
    this.numeroRua = '',
    this.complementoRua = '',
    this.bairro = '',
    this.cidade = '',
    this.estado = '',
    this.cep = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'ativo': ativo,
      'nome': nome,
      'sobrenome': sobrenome,
      'nascimento': nascimento,
      'sexo': sexo,
      'cpf': cpf,
      'rg': rg,
      'email': email,
      'telefone': telefone,
      'celular': celular,
      'rua': rua,
      'numeroRua': numeroRua,
      'complementoRua': complementoRua,
      'bairro': bairro,
      'cidade': cidade,
      'estado': estado,
      'cep': cep,
    };
  }

  PessoaEntity.fromMap(Map<String, dynamic> map) {
    nome = map['nome'] ?? '';
    sobrenome = map['sobrenome'] ?? '';
    if (map['nascimento'] != null) {
      if (map['nascimento'] is String) {
        nascimento = map['nascimento'];
      }
    }
    nascimento = map['nascimento'] ?? '';
    sexo = map['sexo'] ?? '';
    cpf = map['cpf'] ?? '';
    rg = map['rg'] ?? '';
    email = map['email'] ?? '';
    telefone = map['telefone'] ?? '';
    celular = map['celular'] ?? '';
    rua = map['rua'] ?? '';
    complementoRua = map['complementoRua'] ?? '';
    numeroRua = map['numeroRua'] ?? '';
    bairro = map['bairro'] ?? '';
    cidade = map['cidade'] ?? '';
    estado = map['estado'] ?? '';
    cep = map['cep'] ?? '';
    ativo = map['ativo'] ?? false;
  }

  int get idade {
    return DateTime.now()
            .difference(DateFormat('dd/MM/yyyy').parse(nascimento))
            .inDays ~/
        365;
  }
}
