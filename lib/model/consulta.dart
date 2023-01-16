class Consulta {
  String id = '';
  String descricao = '';
  String observacao = '';
  String cuidador = '';
  String paciente = '';
  String responsavel = '';
  String medico = '';
  String rua = '';
  String numero = '';
  String bairro = '';
  String cidade = '';
  String estado = '';
  String cep = '';
  String complementoRua = '';
  bool ativo = true;
  DateTime dataConsulta = DateTime.now();
  DateTime dataRealizada = DateTime.now();

  Consulta(
      {this.observacao = '',
      this.descricao = '',
      this.cuidador = '',
      this.paciente = '',
      this.responsavel = '',
      this.rua = '',
      this.numero = '',
      this.bairro = '',
      this.cidade = '',
      this.estado = '',
      this.cep = '',
      this.complementoRua = '',
      this.medico = ''});

  Consulta.fromMap(Map<String, dynamic> json) {
    ativo = json['ativo'];
    observacao = json['observacao'];
    descricao = json['descricao'];
    paciente = json['paciente'];
    responsavel = json['responsavel'];
    medico = json['medico'];
    rua = json['rua'];
    numero = json['numero'];
    bairro = json['bairro'];
    cidade = json['cidade'];
    estado = json['estado'];
    cep = json['cep'];
    complementoRua = json['complementoRua'];
  }

  Map<String, dynamic> toMap() {
    return {
      'descricao': descricao,
      'ativo': ativo,
      'observacao': observacao,
      'responsavel': responsavel,
      'medico': medico,
      'paciente': paciente,
      'dataCadastro': DateTime.now().toString(),
      'rua': rua,
      'numero': numero,
      'bairro': bairro,
      'cidade': cidade,
      'estado': estado,
      'cep': cep,
      'complementoRua': complementoRua,
    };
  }
}
