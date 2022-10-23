import 'package:cangurugestor/classes/atividade.dart';
import 'package:cangurugestor/classes/consulta.dart';
import 'package:cangurugestor/classes/medicamentos.dart';
import 'package:cangurugestor/classes/pessoa.dart';
import 'package:cangurugestor/classes/diagnostico.dart';
import 'package:cangurugestor/classes/prescricao.dart';
import 'package:cangurugestor/classes/responsavel.dart';

class Paciente extends Pessoa {
  bool ativo = false;
  String id = '';
  String? dataCadastro;
  String idResponsavel = '';
  Responsavel? responsavel;
  Diagnostico? diagnostico;
  List<Consulta>? consultas = [];
  List<Medicamento>? medicamentos = [];
  List<Atividade>? atividades = [];
  List<String> cuidadores = [];
  Prescricao? prescricao = Prescricao();

  Paciente(
      {String cpf = '',
      String nome = '',
      String sobrenome = '',
      String nascimento = '',
      this.id = '',
      this.dataCadastro = '',
      this.diagnostico,
      this.prescricao,
      this.ativo = false,
      this.consultas,
      this.atividades,
      this.medicamentos,
      this.idResponsavel = ''})
      : super(
          cpf: cpf,
          sobrenome: sobrenome,
          nome: nome,
          nascimento: nascimento,
        );

  Paciente.fromMap(Map<String, dynamic> map) : super.fromMap(map) {
    ativo = map['ativo'] ?? true;
    sobrenome = map['sobrenome'];
    id = map['id'] ?? '';
    //cuidadores = map['cuidadores'] ?? [];
    idResponsavel = map['responsavel'];
    dataCadastro = map['dataCadastro'];
    diagnostico = map['diagnostico'] == null
        ? Diagnostico()
        : Diagnostico.fromMap(map['diagnostico']);
  }

  Map<String, dynamic> toMap() {
    return {
      'cpf': cpf,
      'nome': nome,
      'sobrenome': sobrenome,
      'nascimento': nascimento,
      'email': email,
      'responsavel': idResponsavel,
      'telefone': telefone,
      'ativo': ativo,
      'dataCadastro': DateTime.now().toString(),
      'diagnostico': diagnostico?.toMap(),
      'prescricao': prescricao?.toMap(),
      'cuidadores': cuidadores.map((e) => null).toList(),
    };
  }
}
