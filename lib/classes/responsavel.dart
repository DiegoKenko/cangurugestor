import 'package:cangurugestor/classes/pessoa.dart';

class Responsavel extends Pessoa {
  List<String>? idCuidadores;
  List<String>? idPacientes;
  String? idContrato;
  String? senha;
  bool ativo = false;
  String? idGestor;
  String? id;

  Responsavel(
      {String cpf = '',
      String nome = '',
      String nascimento = '',
      String email = '',
      String telefone = '',
      String rua = '',
      String numeroRua = '',
      String cep = '',
      String complementoRua = '',
      String bairro = '',
      String cidade = '',
      String estado = '',
      this.id = '',
      this.idGestor = '',
      this.senha = '',
      this.ativo = false,
      this.idContrato})
      : super(
          cpf: cpf,
          rua: rua,
          numeroRua: numeroRua,
          complementoRua: complementoRua,
          bairro: bairro,
          cidade: cidade,
          cep: cep,
          estado: estado,
          nome: nome,
          email: email,
          nascimento: nascimento,
          telefone: telefone,
        );

  Responsavel.fromMap(Map<String, dynamic> map) : super.fromMap(map) {
    idCuidadores = map['idCuidadores'];
    idPacientes = map['idPacientes'];
    senha = map['senha'];
    ativo = map['ativo'];
    nome = map['nome'];
    sobrenome = map['sobrenome'];
    nascimento = map['nascimento'];
    email = map['email'];
    telefone = map['telefone'];
    cpf = map['cpf'];
    ativo = map['ativo'];
    idGestor = map['gestor'];
    cep = map['cep'];
    estado = map['estado'];
    cidade = map['cidade'];
    bairro = map['bairro'];
    complementoRua = map['complementoRua'];
    numeroRua = map['complementoRua'];
    rua = map['rua'];
  }

  Map<String, dynamic> toMap() {
    return {
      'cpf': cpf,
      'nome': nome,
      'sobrenome': sobrenome,
      'nascimento': nascimento,
      'email': email,
      'gestor': idGestor,
      'idPacientes': idPacientes,
      'idCuidadores': idCuidadores,
      'telefone': telefone,
      'contrato': idContrato ?? {},
      'ativo': ativo,
      'cep': cep,
      'rua': rua,
      'complementoRua': complementoRua,
      'bairro': bairro,
      'cidade': cidade,
      'estado': estado,
    };
  }

  setId(String idRes) {
    id = idRes;
  }
}
