import 'package:cangurugestor/domain/entity/cuidador_entity.dart';
import 'package:cangurugestor/domain/entity/paciente_entity.dart';
import 'package:cangurugestor/domain/entity/responsavel_entity.dart';

class ConsultaEntity {
  String id = '';
  String descricao = '';
  String observacao = '';
  CuidadorEntity cuidador = CuidadorEntity();
  PacienteEntity paciente = PacienteEntity();
  ResponsavelEntity? responsavel;
  ResponsavelEntity? responsavelId;
  String medico = '';
  String rua = '';
  String numeroRua = '';
  String bairro = '';
  String cidade = '';
  String estado = '';
  String cep = '';
  String complementoRua = '';
  bool ativo = true;
  DateTime dataRealizada = DateTime.now();
  DateTime dataMarcada = DateTime.now();

  ConsultaEntity({
    this.observacao = '',
    required this.descricao,
    this.rua = '',
    this.numeroRua = '',
    this.bairro = '',
    this.cidade = '',
    this.estado = '',
    this.cep = '',
    this.complementoRua = '',
    this.medico = '',
    required this.responsavelId,
    required this.dataRealizada,
  });

  ConsultaEntity.initOnAdd(this.paciente);

  ConsultaEntity.fromMap(Map<String, dynamic> json) {
    ativo = json['ativo'];
    observacao = json['observacao'];
    descricao = json['descricao'];
    medico = json['medico'];
    rua = json['rua'];
    numeroRua = json['numeroRua'];
    bairro = json['bairro'];
    cidade = json['cidade'];
    estado = json['estado'];
    cep = json['cep'];
    complementoRua = json['complementoRua'];
  }

  Map<String, dynamic> toMap() {
    return {
      'descricao': descricao,
      'ativo': ativo,
      'observacao': observacao,
      'medico': medico,
      'dataCadastro': DateTime.now().toString(),
      'rua': rua,
      'numeroRua': numeroRua,
      'bairro': bairro,
      'cidade': cidade,
      'estado': estado,
      'cep': cep,
      'complementoRua': complementoRua,
    };
  }
}
