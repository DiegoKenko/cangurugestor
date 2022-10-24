import 'package:cangurugestor/classes/paciente.dart';
import 'package:cangurugestor/classes/pessoa.dart';
import 'package:cangurugestor/classes/responsavel.dart';

class Cuidador extends Pessoa {
  String id = '';
  List<Paciente>? pacientes;
  List<String>? idPacientes;
  DateTime? dataCadastro;
  bool ativo = false;
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
      'senha': senha ?? 'canguruX',
      'dataCadastro': DateTime.now().toString(),
    };
  }
}
