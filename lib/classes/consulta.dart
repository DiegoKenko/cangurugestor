class Consulta {
  String id = '';
  String observacao = '';
  String nome = '';
  String criador = '';
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

  Consulta(
      {this.observacao = '',
      this.nome = '',
      this.criador = '',
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
    nome = json['nome'];
    criador = json['criador'];
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
      'nome': nome,
      'ativo': ativo,
      'criador': criador,
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
