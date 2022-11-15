import 'package:cangurugestor/classes/local.dart';

class Consulta {
  String data = '';
  String id = '';
  String hora = '';
  String observacao = '';
  String nome = '';
  String descricao = '';
  String criador = '';
  String cuidador = '';
  String paciente = '';
  String responsavel = '';
  String medico = '';
  Local? local;
  bool ativo = true;

  Consulta(
      {this.data = '',
      this.hora = '',
      this.observacao = '',
      this.nome = '',
      this.descricao = '',
      this.criador = '',
      this.cuidador = '',
      this.paciente = '',
      this.responsavel = '',
      this.local,
      this.medico = ''});

  Consulta.fromMap(Map<String, dynamic> json) {
    ativo = json['ativo'];
    observacao = json['observacao'];
    nome = json['nome'];
    descricao = json['descricao'];
    criador = json['criador'];
    cuidador = json['cuidador'];
    paciente = json['paciente'];
    responsavel = json['responsavel'];
    medico = json['medico'];
  }

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'descricao': descricao,
      'ativo': ativo,
      'observacao': observacao,
      'responsavel': responsavel,
      'medico': medico,
      'paciente': paciente,
      'dataCadastro': DateTime.now().toString(),
    };
  }
}
