import 'package:cangurugestor/classes/cuidador.dart';
import 'package:cangurugestor/classes/paciente.dart';
import 'package:cangurugestor/classes/pessoa.dart';

class Responsavel extends Pessoa {
  List<Cuidador>? cuidadores;
  List<Paciente>? pacientes;
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
      this.cuidadores,
      this.pacientes,
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
    if ((map['cuidadores'] as Map).isNotEmpty) {
      cuidadores = map['cuidadores']?.map((e) => Cuidador.fromMap(e))?.toList();
    }
    if ((map['pacientes'] as Map).isNotEmpty) {
      pacientes = map['pacientes']?.map((e) => Paciente.fromMap(e))?.toList();
    }
    if ((map['contrato'] as Map).isNotEmpty) {
      idContrato = map['contrato'];
    }
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
      'telefone': telefone,
      'cuidadores': cuidadores ?? {},
      'pacientes': pacientes ?? {},
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
