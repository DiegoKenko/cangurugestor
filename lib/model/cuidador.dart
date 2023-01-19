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
  }) : super(
          cpf: cpf,
          nome: nome,
          nascimento: nascimento,
          email: email,
          telefone: telefone,
        );

  Cuidador.fromMap(Map<String, dynamic> map) : super.fromMap(map) {
    id = map['id'] ?? '';
    idPacientes = map['idPacientes'];
    dataCadastro = DateTime.parse(map['dataCadastro']);
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
      'telefone': telefone,
      'ativo': ativo,
      'idPacientes': idPacientes,
      'senha': senha ?? 'canguruX',
      'dataCadastro': DateTime.now().toString(),
    };
  }
}
