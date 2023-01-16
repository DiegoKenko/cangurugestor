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
  EnumIntervalo frequenciaMedida = EnumIntervalo.dias;
  EnumIntervalo duracaoMedida = EnumIntervalo.minutos;
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
    this.duracaoMedida = EnumIntervalo.minutos,
    this.frequenciaQuantidade = 0,
    this.frequenciaMedida = EnumIntervalo.minutos,
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
    duracaoMedida = EnumIntervalo.values.firstWhere(
        (element) => element.name == map['duracaoMedida'],
        orElse: () => EnumIntervalo.minutos);
    frequenciaMedida = EnumIntervalo.values.firstWhere(
        (element) => element.name == map['frequenciaMedida'],
        orElse: () => EnumIntervalo.minutos);
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
