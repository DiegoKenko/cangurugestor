import 'package:cangurugestor/global.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Tarefa {
  String nome = '';
  String id = '';
  String idTipo = '';
  EnumTarefa tipo = EnumTarefa.nenhuma;
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
  }

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'id': id,
      'idTipo': idTipo,
      'tipo': tipo.name,
      'descricao': descricao,
      'dateTime': dateTime,
      'date': date,
      'time': time,
      'observacao': observacao,
      'concluida': concluida,
    };
  }

  void setTimeFromTimeOfDay(TimeOfDay time) {
    this.time = DateFormat('HH:mm').format(DateTime(time.hour, time.minute));
    dateTime = DateTime(
      dateTime.year,
      dateTime.month,
      dateTime.day,
      time.hour,
      time.minute,
    );
  }

  void setDateFromDateTime(DateTime date) {
    this.date = DateFormat('dd/MM/yyyy').format(date);
    dateTime = DateTime(
      date.year,
      date.month,
      date.day,
      dateTime.hour,
      dateTime.minute,
    );
  }

  void setTimeFromString(String time) {
    this.time = time;
    dateTime = DateTime(
      dateTime.year,
      dateTime.month,
      dateTime.day,
      int.parse(time.split(':')[0]),
      int.parse(time.split(':')[1]),
    );
  }

  void setDateFromString(String date) {
    this.date = date;
    dateTime = DateTime(
      int.parse(date.split('/')[2]),
      int.parse(date.split('/')[1]),
      int.parse(date.split('/')[0]),
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
