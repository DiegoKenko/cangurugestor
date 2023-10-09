import 'package:cangurugestor/enum/enum_status.dart';
import 'package:cangurugestor/enum/enum_tarefa.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Tarefa {
  String nome = '';
  String id = '';
  String idTipo = '';
  EnumTarefa tipo = EnumTarefa.nenhuma;
  EnumStatus status = EnumStatus.nenhum;
  String descricaoTipo = '';
  DateTime dateTime = DateTime.now();
  String date = '';
  String time = '';
  String descricao = '';
  String observacao = '';
  bool concluida = false;
  String dataConclusao = '';
  String horaConclusao = '';
  Tarefa({
    this.nome = '',
    this.idTipo = '',
    this.tipo = EnumTarefa.nenhuma,
    this.observacao = '',
    this.concluida = false,
  }) {
    date = DateFormat('dd/MM/yyyy').format(dateTime);
    time = DateFormat('HH:mm').format(dateTime);
  }

  Tarefa.init({
    required this.dateTime,
    required this.nome,
    required this.descricao,
    required this.observacao,
    required this.tipo,
    required this.idTipo,
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
    observacao = json['observacao'];
    concluida = json['concluida'];
    dataConclusao = json['dataConclusao'] ?? '';
    horaConclusao = json['horaConclusao'] ?? '';
  }

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'idTipo': idTipo,
      'tipo': tipo.name,
      'descricao': descricao,
      'dateTime': dateTime,
      'date': date,
      'time': time,
      'observacao': observacao,
      'concluida': concluida,
      'dataConclusao': dataConclusao,
      'horaConclusao': horaConclusao,
    };
  }

  void setTimeFromTimeOfDay(TimeOfDay t) {
    time = DateFormat('HH:mm').format(DateTime(t.hour, t.minute));
    dateTime = DateTime(
      dateTime.year,
      dateTime.month,
      dateTime.day,
      t.hour,
      t.minute,
    );
  }

  void setDateFromDateTime(DateTime d) {
    date = DateFormat('dd/MM/yyyy').format(d);
    dateTime = DateTime(
      d.year,
      d.month,
      d.day,
      dateTime.hour,
      dateTime.minute,
    );
  }

  void setTimeFromString(String t) {
    if (t.isEmpty) return;
    time = t;
    dateTime = DateTime(
      dateTime.year,
      dateTime.month,
      dateTime.day,
      int.parse(t.split(':')[0]),
      int.parse(t.split(':')[1]),
    );
  }

  void setDateFromString(String d) {
    if (d.isEmpty) return;
    date = d;
    dateTime = DateTime(
      int.parse(d.split('/')[2]),
      int.parse(d.split('/')[1]),
      int.parse(d.split('/')[0]),
      dateTime.hour,
      dateTime.minute,
    );
  }

  void setDateTime(DateTime dateTime) {
    this.dateTime = dateTime;
    date = DateFormat('dd/MM/yyyy').format(dateTime);
    time = DateFormat('HH:mm').format(dateTime);
  }
}
