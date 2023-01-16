import 'package:cangurugestor/model/atividade.dart';
import 'package:cangurugestor/model/consulta.dart';
import 'package:cangurugestor/model/medicamento.dart';
import 'package:cangurugestor/model/pessoa.dart';
import 'package:cangurugestor/model/diagnostico.dart';
import 'package:cangurugestor/model/prescricao.dart';
import 'package:cangurugestor/model/responsavel.dart';

class Paciente extends Pessoa {
  bool ativo = true;
  String id = '';
  String? dataCadastro;
  String idResponsavel = '';
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
    this.id = '',
    this.dataCadastro = '',
    this.prescricao,
    this.ativo = false,
    this.consultas = const [],
    this.atividades = const [],
    this.medicamentos = const [],
    this.idResponsavel = '',
  }) : super(
          cpf: cpf,
          sobrenome: sobrenome,
          nome: nome,
          nascimento: nascimento,
        );

  Paciente.fromMap(Map<String, dynamic> map) : super.fromMap(map) {
    ativo = map['ativo'] ?? true;
    sobrenome = map['sobrenome'];
    id = map['id'] ?? '';
    idResponsavel = map['responsavel'];
    dataCadastro = map['dataCadastro'];
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
      'dataCadastro': DateTime.now().toIso8601String(),
      'cuidadores': cuidadores.map((e) => null).toList(),
    };
  }
}
