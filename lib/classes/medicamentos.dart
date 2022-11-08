import 'package:cangurugestor/global.dart';

class Medicamento {
  String nome = '';
  String descricao = '';
  String tipo = '';
  String formaDeUso = '';
  String duracao = '';
  double quantidade = 0;
  double frequenciaQuantidade = 0;
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
    this.formaDeUso = '',
    this.quantidade = 0,
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

    observacao = map['observacao'];
    status = map['status'];
    ativo = map['ativo'];
    quantidade = double.parse(map['quantidade'].toString());
    frequenciaQuantidade = double.parse(map['frequenciaQuantidade'].toString());
    frequencia = EnumFrequencia.values.firstWhere(
        (element) => element.name == map['frequencia'],
        orElse: () => EnumFrequencia.minutos);
  }

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'descricao': descricao,
      'tipo': tipo,
      'duracao': duracao,
      'observacao': observacao,
      'status': status,
      'ativo': ativo,
      'quantidade': quantidade,
      'frequenciaQuantidade': frequenciaQuantidade,
      'frequencia': frequencia.toString().split(".").last,
    };
  }
}
