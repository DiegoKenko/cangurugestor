class Diagnostico {
  String? id;
  String? medico;
  DateTime? dataEmissao;
  String? titulo;
  String? descricao;

  Diagnostico({
    this.id,
    this.medico,
    this.dataEmissao,
    this.titulo,
    this.descricao,
  });

  Diagnostico.fromMap(Map<String, dynamic> map) {
    id = map['id'] ?? '';
    medico = map['medico'] ?? '';
    dataEmissao = DateTime.parse(map['dataEmissao']);
    titulo = map['titulo'] ?? '';
    descricao = map['descricao'] ?? '';
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id ?? '',
      'medico': medico ?? '',
      'dataEmissao': dataEmissao ?? '',
      'titulo': titulo ?? '',
      'descricao': descricao ?? '',
    };
  }
}
