class LocalEntity {
  String? nome;
  String? descricao;
  String? rua;
  String? numeroRua;
  String? complementoRua;
  String? bairro;
  String? cidade;
  String? estado;
  String? cep;

  LocalEntity({
    this.nome,
    this.descricao,
    this.rua,
    this.numeroRua,
    this.complementoRua,
    this.bairro,
    this.cidade,
    this.estado,
    this.cep,
  });

  LocalEntity.fromJson(Map<String, dynamic> json) {
    nome = json['nome'];
    descricao = json['descricao'];
    rua = json['rua'];
    complementoRua = json['complementoRua'];
    numeroRua = json['numeroRua'];
    bairro = json['bairro'];
    cidade = json['cidade'];
    estado = json['estado'];
    cep = json['cep'];
  }

  Map<String, dynamic> toMap() {
    return {
      'nome': nome!,
      'descricao': descricao,
      'rua': rua ?? '',
      'complementoRua': complementoRua ?? '',
      'numeroRua': numeroRua ?? '',
      'bairro': bairro ?? '',
      'cidade': cidade ?? '',
      'estado': estado ?? '',
      'cep': cep ?? '',
    };
  }
}
