import 'package:cangurugestor/enum/enum_intervalo.dart';
import 'package:cangurugestor/model/paciente.dart';
import 'package:cangurugestor/model/tarefa.dart';
// ignore: unused_import
import 'package:cangurugestor/global.dart';

class Medicamento {
  String nome = '';
  String descricao = '';
  String tipo = '';
  String formaDeUso = '';
  String duracao = '';
  double dose = 0;
  String doseUM = '';
  double intervaloQuantidade = 0;
  String observacao = '';
  String status = '';
  String id = '';
  bool ativo = true;
  EnumIntervalo intervalo = EnumIntervalo.minutos;
  List<Tarefa> tarefas = [];
  DateTime? dataInicio;
  Paciente paciente = Paciente();

  Medicamento({
    this.nome = '',
    this.id = '',
    this.descricao = '',
    this.tipo = '',
    this.duracao = '',
    this.formaDeUso = '',
    this.dose = 0,
    this.observacao = '',
    this.status = '',
    this.ativo = false,
    this.intervalo = EnumIntervalo.minutos,
  });

  Medicamento.initOnAdd(this.paciente);

  Medicamento.fromMap(Map<String, dynamic> map) {
    nome = map['nome'];
    descricao = map['descricao'];
    tipo = map['tipo'];
    duracao = map['duracao'];

    observacao = map['observacao'];
    status = map['status'];
    ativo = map['ativo'];
    dose = double.parse(map['dose'].toString());
    intervaloQuantidade = double.parse(map['intervaloQuantidade'].toString());
    intervalo = EnumIntervalo.values.firstWhere(
      (element) => element.name == map['intervalo'],
      orElse: () => EnumIntervalo.minutos,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'descricao': descricao,
      'tipo': tipo,
      'duracao': duracao,
      'observacao': observacao,
      'status': status,
      'ativo': ativo,
      'dose': dose,
      'intervaloQuantidade': intervaloQuantidade,
      'intervalo': intervalo.toString().split('.').last,
    };
  }
}
