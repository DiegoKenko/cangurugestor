class ContratoEntity {
  String? contratante;
  String? contratado;
  DateTime? dataInicio;
  DateTime? dataFim;
  double? valor;
  String? observacao;
  String? id;
  DateTime? dataCadastro;
  DateTime? dataAtualizacao;
  bool? ativo;

  ContratoEntity.fromMap(Map<String, dynamic> map) {
    contratante = map['contratante'];
    contratado = map['contratado'];
    dataInicio = DateTime.parse(map['dataInicio']);
    dataFim = DateTime.parse(map['dataFim']);
    valor = map['valor'];
    observacao = map['observacao'];
    id = map['id'];
    dataCadastro = DateTime.parse(map['dataCadastro']);
    dataAtualizacao = DateTime.parse(map['dataAtualizacao']);
    ativo = map['ativo'];
  }
}
