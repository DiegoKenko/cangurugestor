class Atividade {
  String? nome;
  String id = '';
  String descricao = '';
  String tipo = '';
  String duracao = '';
  String data = '';
  String hora = '';
  String local = '';
  String observacao = '';
  String status = '';
  String frequencia = '';
  String? intensidade;
  double? unidadeMedida;

  Atividade({
    this.nome = '',
    this.descricao = '',
    this.tipo = '',
    this.duracao = '',
    this.data = '',
    this.hora = '',
    this.local = '',
    this.observacao = '',
    this.status = '',
    this.frequencia = '',
    this.intensidade,
    this.unidadeMedida,
  });

  Atividade.fromMap(Map<String, dynamic> map) {
    nome = map['nome'];
    descricao = map['descricao'];
    tipo = map['tipo'];
    duracao = map['duracao'];
    data = map['data'];
    hora = map['hora'];
    local = map['local'];
    observacao = map['observacao'];
    status = map['status'];
    frequencia = map['frequencia'];
    intensidade = map['intensidade'];
    unidadeMedida = map['unidadeMedida'];
  }

  Map<String, dynamic> toMap() {
    return {
      'nome': nome ?? '',
      'descricao': descricao,
      'tipo': tipo,
      'duracao': duracao,
      'data': data,
      'hora': hora,
      'local': local,
      'observacao': observacao,
      'status': status,
      'frequencia': frequencia,
      'intensidade': intensidade ?? '',
      'unidadeMedida': unidadeMedida ?? '',
    };
  }
}
