import 'package:cangurugestor/classes/local.dart';

class Consulta {
  String data = '';
  String id = '';
  String hora = '';
  String status = '';
  String observacao = '';
  String nome = '';
  String descricao = '';
  String criador = '';
  String cuidador = '';
  String paciente = '';
  String responsavel = '';
  String medico = '';
  Local? local;

  Consulta(
      {this.data = '',
      this.hora = '',
      this.status = '',
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
    data = json['data'];
    hora = json['hora'];
    status = json['status'];
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
      'data': data,
      'nome': nome,
      'hora': hora,
      'observacao': observacao,
      'responsavel': responsavel,
      'medico': medico,
      'paciente': paciente,
      'dataCadastro': DateTime.now().toString(),
    };
  }
}
