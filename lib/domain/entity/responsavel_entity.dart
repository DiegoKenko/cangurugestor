import 'package:cangurugestor/domain/entity/cuidador_entity.dart';
import 'package:cangurugestor/domain/entity/gestor_entity.dart';
import 'package:cangurugestor/domain/entity/paciente_entity.dart';
import 'package:cangurugestor/domain/entity/pessoa_entity.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ResponsavelEntity extends PessoaEntity {
  List<CuidadorEntity> cuidadores = [];
  List<PacienteEntity> pacientes = [];
  List<String> idCuidadores = [];
  String idContrato = '';
  String idGestor = '';
  GestorEntity gestor = GestorEntity();

  ResponsavelEntity({
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
    required this.idGestor,
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

  ResponsavelEntity.initOnAdd(this.idGestor);

  ResponsavelEntity.fromPessoa(PessoaEntity pessoa) {
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
  ResponsavelEntity.fromUser(User user) {
    id = user.uid;
    email = user.email ?? '';
    nome = user.displayName ?? '';
  }

  ResponsavelEntity.fromMap(Map<String, dynamic> map) : super.fromMap(map) {
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
    idGestor = map['idGestor'];
  }

  @override
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
      'rua': rua,
      'numeroRua': numeroRua,
      'nascimento': nascimento,
      'nome': nome,
      'sobrenome': sobrenome,
      'telefone': telefone,
      'idGestor': idGestor,
    };
  }
}
