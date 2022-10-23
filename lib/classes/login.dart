class Login {
  String? doc;
  String? funcao;
  String? colecao;
  String? cpf;
  String? senha;
  bool? ativo;

  Login({
    required this.colecao,
    required this.cpf,
    required this.doc,
    required this.funcao,
    required this.senha,
    required this.ativo,
  });

  Login.fromMap(Map<String, dynamic> map) {
    doc = map['doc'];
    funcao = map['funcao'];
    colecao = map['colecao'];
    senha = map['senha'];
    cpf = map['cpf'];
    ativo = map['ativo'];
  }

  Map<String, dynamic> toMap() {
    return {
      'cpf': cpf,
      'funcao': funcao,
      'colecao': colecao,
      'senha': senha,
      'doc': doc,
      'ativo': ativo,
    };
  }
}
