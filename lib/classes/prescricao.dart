import 'package:cangurugestor/classes/atividade.dart';
import 'package:cangurugestor/classes/medicamentos.dart';

class Prescricao {
  List<Atividade>? atividades;
  List<Medicamento>? medicamentos;
  DateTime? inicio;
  DateTime? dataCriacao;
  DateTime? fim;
  String? criador;
  String? status;
  String? observacao;
  String? nome;
  String? descricao;

  Prescricao.fromMap(Map<String, dynamic> map) {
    //atividades = map['atividades']?.map((e) => Atividade.fromMap(e))?.toList();
    medicamentos =
        map['medicamentos']?.map((e) => Medicamento.fromMap(e))?.toList();
    inicio = DateTime.parse(map['inicio']);
    dataCriacao = DateTime.parse(map['dataCriacao']);
    fim = DateTime.parse(map['fim']);
    criador = map['criador'];
    status = map['status'];
    observacao = map['observacao'];
    nome = map['nome'];
    descricao = map['descricao'];
  }

  Prescricao({
    this.atividades,
    this.medicamentos,
    this.inicio,
    this.dataCriacao,
    this.fim,
    this.criador,
    this.status,
    this.observacao,
    this.nome,
    this.descricao,
  });

  Map<String, dynamic> toMap() {
    return {
      'atividades': atividades ?? '',
      'medicamentos': medicamentos ?? '',
      'inicio': inicio ?? '',
      'dataCriacao': dataCriacao ?? '',
      'fim': fim ?? '',
      'criador': criador ?? '',
      'status': status ?? '',
      'observacao': observacao ?? '',
      'nome': nome ?? '',
      'descricao': descricao ?? '',
    };
  }
}
