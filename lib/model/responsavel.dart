import 'package:cangurugestor/model/cuidador.dart';
import 'package:cangurugestor/model/gestor.dart';
import 'package:cangurugestor/model/paciente.dart';
import 'package:cangurugestor/model/pessoa.dart';

class Responsavel extends Pessoa {
  List<Cuidador> cuidadores = [];
  List<Paciente> pacientes = [];
  List<String> idCuidadores = [];
  List<String> idPacientes = [];
  String idContrato = '';
  Gestor gestor = Gestor();

  Responsavel({
    String cpf = '',
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
    this.idContrato = '',
  }) : super(
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
    nascimento = map['nascimento'];
    nome = map['nome'];
    rua = map['rua'];
    numeroRua = map['numeroRua'] ?? '';
    sobrenome = map['sobrenome'];
    telefone = map['telefone'];
    idPacientes = map['idPacientes'].cast<String>();
  }

  @override
  Map<String, dynamic> toMap() {
    idCuidadores = [];
    for (var cuidador in cuidadores) {
      if (!idCuidadores.contains(cuidador.id)) {
        idCuidadores.add(cuidador.id);
      }
    }
    idPacientes = [];
    for (var paciente in pacientes) {
      if (!idPacientes.contains(paciente.id)) {
        idPacientes.add(paciente.id);
      }
    }
    return {
      'ativo': ativo,
      'bairro': bairro,
      'cep': cep,
      'cidade': cidade,
      'complementoRua': complementoRua,
      'cpf': cpf,
      'estado': estado,
      'email': email,
      'rua': rua,
      'numeroRua': numeroRua,
      'nascimento': nascimento,
      'nome': nome,
      'sobrenome': sobrenome,
      'telefone': telefone,
      'idPacientes': idPacientes,
    };
  }

  setId(String idRes) {
    id = idRes;
  }
}
