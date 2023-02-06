import 'package:cangurugestor/model/cuidador.dart';
import 'package:cangurugestor/model/paciente.dart';
import 'package:cangurugestor/model/responsavel.dart';

class Consulta {
  String id = '';
  String descricao = '';
  String observacao = '';
  Cuidador cuidador = Cuidador();
  Paciente paciente = Paciente();
  Responsavel responsavel = Responsavel();
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

  Consulta({
    this.observacao = '',
    this.descricao = '',
    this.rua = '',
    this.numeroRua = '',
    this.bairro = '',
    this.cidade = '',
    this.estado = '',
    this.cep = '',
    this.complementoRua = '',
    this.medico = '',
  });

  Consulta.fromMap(Map<String, dynamic> json) {
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
