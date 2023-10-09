import 'package:cangurugestor/const/enum/enum_intervalo.dart';
import 'package:cangurugestor/domain/entity/cuidador_entity.dart';
import 'package:cangurugestor/domain/entity/paciente_entity.dart';
import 'package:cangurugestor/domain/entity/responsavel_entity.dart';

class AtividadeEntity {
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
  PacienteEntity paciente = PacienteEntity();
  CuidadorEntity cuidador = CuidadorEntity();
  ResponsavelEntity? responsavel;
  String responsavelId = '';

  AtividadeEntity({
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
    required this.responsavelId,
  });

  AtividadeEntity.initOnAdd(this.paciente, this.responsavelId);

  AtividadeEntity.fromMap(Map<String, dynamic> map) {
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
      orElse: () => EnumIntervalo.minutos,
    );
    frequenciaMedida = EnumIntervalo.values.firstWhere(
      (element) => element.name == map['frequenciaMedida'],
      orElse: () => EnumIntervalo.minutos,
    );
    responsavelId = map['responsavelId'] ?? '';
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
      'duracaoMedida': duracaoMedida.toString().split('.').last,
      'frequenciaMedida': frequenciaMedida.toString().split('.').last,
      'responsavelId': responsavelId,
    };
  }
}
