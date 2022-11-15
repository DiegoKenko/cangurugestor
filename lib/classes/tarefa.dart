import 'package:cangurugestor/global.dart';
import 'package:intl/intl.dart';

class Tarefa {
  String nome = '';
  String id = '';
  String idTipo = '';
  EnumTarefa? tipo = EnumTarefa.nenhuma;
  String descricaoTipo = '';
  DateTime dateTime = DateTime.now();
  String date = '';
  String time = '';
  String descricao = '';
  String observacao = '';
  bool concluida = false;
  Tarefa({
    this.nome = '',
    this.idTipo = '',
    this.tipo = EnumTarefa.nenhuma,
    required this.dateTime,
    this.descricao = '',
    this.observacao = '',
    this.concluida = false,
  }) {
    date = DateFormat('dd/MM/yyyy').format(dateTime);
    time = DateFormat('HH:mm').format(dateTime);
  }

  Tarefa.fromMap(Map<String, dynamic> json) {
    nome = json['nome'];
    idTipo = json['idTipo'];
    tipo =
        EnumTarefa.values.firstWhere((element) => element.name == json['tipo']);
    dateTime = DateTime.parse(json['dateTime'].toDate().toString());
    date = json['date'];
    time = json['time'];
    descricao = json['descricao'];
    observacao = json['observacao'];
    concluida = json['concluida'];
  }

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'id': id,
      'idTipo': idTipo,
      'tipo': tipo!.name,
      'dateTime': dateTime,
      'date': DateFormat('dd/MM/yyyy').format(dateTime),
      'time': DateFormat('HH:mm').format(dateTime),
      'descricao': descricao,
      'observacao': observacao,
      'concluida': concluida,
    };
  }
}