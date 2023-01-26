import 'package:cangurugestor/model/atividade.dart';
import 'package:cangurugestor/model/consulta.dart';
import 'package:cangurugestor/model/medicamento.dart';
import 'package:cangurugestor/model/pessoa.dart';
import 'package:cangurugestor/model/prescricao.dart';
import 'package:cangurugestor/model/responsavel.dart';

class Paciente extends Pessoa {
  String? dataCadastro;
  Responsavel responsavel = Responsavel();
  List<Consulta> consultas = [];
  List<Medicamento> medicamentos = [];
  List<Atividade> atividades = [];
  List cuidadores = [];
  Prescricao? prescricao = Prescricao();

  Paciente({
    String cpf = '',
    String nome = '',
    String sobrenome = '',
    String nascimento = '',
    String id = '',
    bool ativo = false,
    this.dataCadastro = '',
    this.prescricao,
    this.consultas = const [],
    this.atividades = const [],
    this.medicamentos = const [],
  }) : super(
          id: id,
          ativo: ativo,
          cpf: cpf,
          sobrenome: sobrenome,
          nome: nome,
          nascimento: nascimento,
        );

  Paciente.fromMap(Map<String, dynamic> map) : super.fromMap(map) {
    ativo = map['ativo'] ?? true;
    sobrenome = map['sobrenome'];
    id = map['id'] ?? '';
    dataCadastro = map['dataCadastro'];
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
      'dataCadastro': DateTime.now().toIso8601String(),
      'cuidadores': cuidadores.map((e) => null).toList(),
    };
  }
}
