import 'package:cangurugestor/classes/cuidador.dart';
import 'package:cangurugestor/classes/paciente.dart';
import 'package:cangurugestor/classes/pessoa.dart';

class Responsavel extends Pessoa {
  List<Cuidador> cuidadores = [];
  List<Paciente> pacientes = [];
  List<String>? idCuidadores;
  List<String>? idPacientes;
  String? idContrato;
  String? senha;
  bool ativo = true;
  String? idGestor;
  String id = '';

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
      this.ativo = true,
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
    ativo = map['ativo'];
    bairro = map['bairro'];
    cep = map['cep'];
    cidade = map['cidade'];
    complementoRua = map['complementoRua'];
    cpf = map['cpf'];
    email = map['email'];
    estado = map['estado'];
    idGestor = map['gestor'];
    nascimento = map['nascimento'];
    nome = map['nome'];
    rua = map['rua'];
    senha = map['senha'];
    sobrenome = map['sobrenome'];
    telefone = map['telefone'];
  }

  Map<String, dynamic> toMap() {
    return {
      'ativo': ativo,
      'bairro': bairro,
      'cep': cep,
      'cidade': cidade,
      'complementoRua': complementoRua,
      'cpf': cpf,
      'estado': estado,
      'email': email,
      'gestor': idGestor,
      'rua': rua,
      'nascimento': nascimento,
      'nome': nome,
      'sobrenome': sobrenome,
      'telefone': telefone,
    };
  }

  setId(String idRes) {
    id = idRes;
  }
}
