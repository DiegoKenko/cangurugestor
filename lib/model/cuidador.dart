import 'package:cangurugestor/model/paciente.dart';
import 'package:cangurugestor/model/pessoa.dart';
import 'package:cangurugestor/model/responsavel.dart';

class Cuidador extends Pessoa {
  String id = '';
  List<Paciente>? pacientes;
  List idPacientes = [];
  DateTime? dataCadastro;
  bool ativo = true;
  String? senha;
  Responsavel? responsavel;
  String? idResponsavel;

  Cuidador({
    String cpf = '',
    String nome = '',
    String nascimento = '',
    String email = '',
    String telefone = '',
    this.pacientes,
    this.idPacientes = const [],
    this.ativo = false,
    this.senha = '',
    this.id = '',
    this.responsavel,
    this.idResponsavel = '',
  }) : super(
          cpf: cpf,
          nome: nome,
          nascimento: nascimento,
          email: email,
          telefone: telefone,
        );

  Cuidador.fromMap(Map<String, dynamic> map) : super.fromMap(map) {
    id = map['id'] ?? '';
    idPacientes = map['pacientes'];
    dataCadastro = DateTime.parse(map['dataCadastro']);
    idResponsavel = map['responsavel'];
    ativo = map['ativo'];
    cpf = map['cpf'];
    nome = map['nome'];
    sobrenome = map['sobrenome'];
    email = map['email'];
    senha = map['senha'];
    telefone = map['telefone'];
  }

  Map<String, dynamic> toMap() {
    return {
      'cpf': cpf,
      'nome': nome,
      'sobrenome': sobrenome,
      'nascimento': nascimento,
      'email': email,
      'responsavel': idResponsavel,
      'telefone': telefone,
      'ativo': ativo,
      'pacientes': idPacientes,
      'senha': senha ?? 'canguruX',
      'dataCadastro': DateTime.now().toString(),
    };
  }
}
