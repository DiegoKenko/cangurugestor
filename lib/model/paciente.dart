import 'package:cangurugestor/model/atividade.dart';
import 'package:cangurugestor/model/consulta.dart';
import 'package:cangurugestor/model/cuidador.dart';
import 'package:cangurugestor/model/medicamento.dart';
import 'package:cangurugestor/model/pessoa.dart';
import 'package:cangurugestor/model/responsavel.dart';

class Paciente extends Pessoa {
  String? dataCadastro;
  Responsavel responsavel = Responsavel();
  List<Consulta> consultas = [];
  List<Medicamento> medicamentos = [];
  List<Atividade> atividades = [];
  List<String> idCuidadores = [];
  List<Cuidador> cuidadores = [];
  String idResponsavel = '';

  Paciente({
    String cpf = '',
    String nome = '',
    String sobrenome = '',
    String nascimento = '',
    String id = '',
    bool ativo = false,
    this.dataCadastro = '',
    this.consultas = const [],
    this.atividades = const [],
    this.medicamentos = const [],
  }) : super(
          id: id,
          ativo: ativo,
          cpf: cpf,
          sobrenome: sobrenome,
          nome: nome,
          nascimento: nascimento,
        );

  Paciente.initOnAdd(this.idResponsavel);

  Paciente.fromMap(Map<String, dynamic> map) : super.fromMap(map) {
    ativo = map['ativo'] ?? true;
    nome = map['nome'];
    sobrenome = map['sobrenome'];
    id = map['id'] ?? '';
    dataCadastro = map['dataCadastro'];
    idCuidadores = List<String>.from(map['idCuidadores'] ?? []);
    idResponsavel = map['idResponsavel'];
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'cpf': cpf,
      'nome': nome,
      'sobrenome': sobrenome,
      'nascimento': nascimento,
      'ativo': ativo,
      'dataCadastro': DateTime.now().toIso8601String(),
      'idCuidadores': idCuidadores,
      'idResponsavel': idResponsavel
    };
  }
}
