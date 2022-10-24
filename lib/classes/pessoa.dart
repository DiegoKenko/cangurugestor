class Pessoa {
  String nome = '';
  String sobrenome = '';
  String nascimento = '';
  String sexo = '';
  String cpf = '';
  String rg = '';
  String email = '';
  String telefone = '';
  String celular = '';
  String rua = '';
  String numeroRua = '';
  String complementoRua = '';
  String bairro = '';
  String cidade = '';
  String estado = '';
  String cep = '';

  Pessoa({
    this.nome = '',
    this.sobrenome = '',
    this.nascimento = '',
    this.sexo = '',
    this.cpf = '',
    this.rg = '',
    this.email = '',
    this.telefone = '',
    this.celular = '',
    this.rua = '',
    this.numeroRua = '',
    this.complementoRua = '',
    this.bairro = '',
    this.cidade = '',
    this.estado = '',
    this.cep = '',
  });

  Pessoa.fromMap(Map<String, dynamic> map) {
    nome = map['nome'] ?? '';
    sobrenome = map['sobrenome'] ?? '';
    if (map['nascimento'] != null) {
      if (map['nascimento'] is String) {
        nascimento = map['nascimento'];
      }
    }
    nascimento = map['nascimento'] ?? '';
    sexo = map['sexo'] ?? '';
    cpf = map['cpf'] ?? '';
    rg = map['rg'] ?? '';
    email = map['email'] ?? '';
    telefone = map['telefone'] ?? '';
    celular = map['celular'] ?? '';
    rua = map['rua'] ?? '';
    complementoRua = map['complementoRua'] ?? '';
    numeroRua = map['numeroRua'] ?? '';
    bairro = map['bairro'] ?? '';
    cidade = map['cidade'] ?? '';
    estado = map['estado'] ?? '';
    cep = map['cep'] ?? '';
  }

  //get idade => nascimento!.difference(DateTime.now()).inDays ~/ 365;
}
