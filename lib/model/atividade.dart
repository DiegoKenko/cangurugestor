import 'package:cangurugestor/global.dart';
import 'package:cangurugestor/model/cuidador.dart';
import 'package:cangurugestor/model/paciente.dart';
import 'package:cangurugestor/model/responsavel.dart';

class Atividade {
  String id = '';
  String descricao = '';
  String tipo = '';
  String local = '';
  String observacao = '';
  String status = '';
  String? intensidade;
  double duracaoQuantidade = 0;
  double frequenciaQuantidade = 0;
  EnumIntervalo frequenciaMedida = EnumIntervalo.dias;
  EnumIntervalo duracaoMedida = EnumIntervalo.minutos;
  bool ativo = true;
  Paciente paciente = Paciente();
  Cuidador cuidador = Cuidador();
  Responsavel responsavel = Responsavel();

  Atividade({
    this.descricao = '',
    this.tipo = '',
    this.duracaoQuantidade = 0,
    this.local = '',
    this.observacao = '',
    this.status = '',
    this.intensidade,
    this.duracaoMedida = EnumIntervalo.minutos,
    this.frequenciaQuantidade = 0,
    this.frequenciaMedida = EnumIntervalo.minutos,
  });

  Atividade.fromMap(Map<String, dynamic> map) {
    descricao = map['descricao'];
    tipo = map['tipo'];
    duracaoQuantidade = map['duracaoQuantidade'];
    local = map['local'];

    observacao = map['observacao'];
    status = map['status'];
    intensidade = map['intensidade'];
    frequenciaQuantidade = map['frequenciaQuantidade'];
    duracaoMedida = EnumIntervalo.values.firstWhere(
        (element) => element.name == map['duracaoMedida'],
        orElse: () => EnumIntervalo.minutos);
    frequenciaMedida = EnumIntervalo.values.firstWhere(
        (element) => element.name == map['frequenciaMedida'],
        orElse: () => EnumIntervalo.minutos);
  }

  Map<String, dynamic> toMap() {
    return {
      'descricao': descricao,
      'local': local,
      'observacao': observacao,
      'status': status,
      'intensidade': intensidade ?? '',
      'tipo': tipo,
      'duracaoQuantidade': duracaoQuantidade,
      'frequenciaQuantidade': frequenciaQuantidade,
      'duracaoMedida': duracaoMedida.toString().split(".").last,
      'frequenciaMedida': frequenciaMedida.toString().split(".").last,
    };
  }
}
