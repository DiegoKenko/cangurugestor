import 'package:cangurugestor/global.dart';

class Medicamento {
  String nome = '';
  String descricao = '';
  String tipo = '';
  String formaDeUso = '';
  String duracao = '';
  double quantidade = 0;
  double frequenciaQuantidade = 0;
  String data = '';
  String dataInicio = '';
  String dataFim = '';
  String hora = '';
  String observacao = '';
  String status = '';
  String id = '';
  bool ativo = true;
  EnumFrequencia? frequencia;

  Medicamento({
    this.nome = '',
    this.id = '',
    this.descricao = '',
    this.tipo = '',
    this.duracao = '',
    this.dataInicio = '',
    this.formaDeUso = '',
    this.dataFim = '',
    this.data = '',
    this.quantidade = 0,
    this.hora = '',
    this.observacao = '',
    this.status = '',
    this.ativo = false,
    this.frequencia = EnumFrequencia.minutos,
  });

  Medicamento.fromMap(Map<String, dynamic> map) {
    nome = map['nome'];
    descricao = map['descricao'];
    tipo = map['tipo'];
    duracao = map['duracao'];
    data = map['data'] ?? '';
    dataInicio = map['dataInicio'];
    dataFim = map['dataFim'];
    hora = map['hora'];
    observacao = map['observacao'];
    status = map['status'];
    ativo = map['ativo'];
    quantidade = double.parse(map['quantidade'].toString());
    frequenciaQuantidade = double.parse(map['frequenciaQuantidade'].toString());
    frequencia = EnumFrequencia.values.firstWhere(
        (element) => element.name == map['frequencia'],
        orElse: () => EnumFrequencia.nenhum);
  }

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'descricao': descricao,
      'tipo': tipo,
      'duracao': duracao,
      'data': data,
      'dataFim': dataFim,
      'dataInicio': dataInicio,
      'hora': hora,
      'observacao': observacao,
      'status': status,
      'ativo': ativo,
      'quantidade': quantidade,
      'frequenciaQuantidade': frequenciaQuantidade,
      'frequencia': frequencia.toString().split(".").last,
    };
  }
}
