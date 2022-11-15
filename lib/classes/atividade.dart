import 'package:cangurugestor/global.dart';

class Atividade {
  String nome = '';
  String id = '';
  String descricao = '';
  String tipo = '';
  String data = '';
  String hora = '';
  String local = '';
  String observacao = '';
  String status = '';
  String? intensidade;
  double duracaoQuantidade = 0;
  double frequenciaQuantidade = 0;
  EnumFrequencia frequenciaMedida = EnumFrequencia.dias;
  EnumFrequencia duracaoMedida = EnumFrequencia.minutos;
  bool ativo = true;

  Atividade({
    this.nome = '',
    this.descricao = '',
    this.tipo = '',
    this.duracaoQuantidade = 0,
    this.local = '',
    this.observacao = '',
    this.status = '',
    this.intensidade,
    this.duracaoMedida = EnumFrequencia.minutos,
    this.frequenciaQuantidade = 0,
    this.frequenciaMedida = EnumFrequencia.minutos,
  });

  Atividade.fromMap(Map<String, dynamic> map) {
    nome = map['nome'];
    descricao = map['descricao'];
    tipo = map['tipo'];
    duracaoQuantidade = map['duracaoQuantidade'];
    data = map['data'];
    hora = map['hora'];
    observacao = map['observacao'];
    status = map['status'];
    intensidade = map['intensidade'];
    frequenciaQuantidade = map['frequenciaQuantidade'];
    duracaoMedida = EnumFrequencia.values.firstWhere(
        (element) => element.name == map['duracaoMedida'],
        orElse: () => EnumFrequencia.minutos);
    frequenciaMedida = EnumFrequencia.values.firstWhere(
        (element) => element.name == map['frequenciaMedida'],
        orElse: () => EnumFrequencia.minutos);
  }

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'descricao': descricao,
      'data': data,
      'hora': hora,
      'observacao': observacao,
      'status': status,
      'intensidade': intensidade ?? '',
      'tipo': tipo,
      'duracaoQuantidade': duracaoQuantidade,
      'frequenciaQuantidade': frequenciaQuantidade,
      'duracaoMedida': duracaoMedida.toString().split(".").last,
      'frequenciaMedida': frequenciaMedida.toString().split(".").last,
    };
  }
}
