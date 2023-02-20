import 'package:cangurugestor/model/pessoa.dart';

class Cuidador extends Pessoa {
  List idPacientes = [];
  DateTime? dataCadastro;

  Cuidador({
    String cpf = '',
    String nome = '',
    String nascimento = '',
    String email = '',
    String rua = '',
    String numeroRua = '',
    String complementoRua = '',
    String bairro = '',
    String cidade = '',
    String estado = '',
    String cep = '',
    String telefone = '',
    this.idPacientes = const [],
  }) : super(
          cpf: cpf,
          nome: nome,
          nascimento: nascimento,
          email: email,
          telefone: telefone,
          bairro: bairro,
          cidade: cidade,
          cep: cep,
          complementoRua: complementoRua,
          estado: estado,
          numeroRua: numeroRua,
          rua: rua,
        );

  Cuidador.fromPessoa(Pessoa pessoa) {
    id = pessoa.id;
    nome = pessoa.nome;
    email = pessoa.email;
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

  Cuidador.fromMap(Map<String, dynamic> map) : super.fromMap(map) {
    id = map['id'] ?? '';
    idPacientes = map['idPacientes'];
    dataCadastro = DateTime.parse(map['dataCadastro']);
    ativo = map['ativo'];
    cpf = map['cpf'];
    nome = map['nome'];
    sobrenome = map['sobrenome'];
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
  Map<String, dynamic> toMap() {
    return {
      'cpf': cpf,
      'nome': nome,
      'sobrenome': sobrenome,
      'nascimento': nascimento,
      'email': email,
      'telefone': telefone,
      'ativo': ativo,
      'idPacientes': idPacientes,
      'dataCadastro': DateTime.now().toString(),
      'rua': rua,
      'numeroRua': numeroRua,
      'complementoRua': complementoRua,
      'bairro': bairro,
      'cidade': cidade,
      'cep': cep,
      'estado': estado,
    };
  }
}
