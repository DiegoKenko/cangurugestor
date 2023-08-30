import 'package:cangurugestor/domain/entity/atividade.dart';
import 'package:cangurugestor/domain/entity/consulta.dart';
import 'package:cangurugestor/domain/entity/cuidador.dart';
import 'package:cangurugestor/domain/entity/medicamento.dart';
import 'package:cangurugestor/domain/entity/pessoa.dart';
import 'package:cangurugestor/domain/entity/responsavel.dart';

class PacienteEntity extends PessoaEntity {
  String? dataCadastro;
  ResponsavelEntity responsavel = ResponsavelEntity();
  List<ConsultaEntity> consultas = [];
  List<MedicamentoEntity> medicamentos = [];
  List<AtividadeEntity> atividades = [];
  List<String> idCuidadores = [];
  List<CuidadorEntity> cuidadores = [];
  String idResponsavel = '';

  PacienteEntity({
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

  PacienteEntity.initOnAdd(this.idResponsavel);

  PacienteEntity.fromMap(Map<String, dynamic> map) : super.fromMap(map) {
    ativo = map['ativo'] ?? true;
    nome = map['nome'];
    sobrenome = map['sobrenome'];
    id = map['id'] ?? '';
    dataCadastro = map['dataCadastro'];
    idCuidadores = List<String>.from(map['idCuidadores']);
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
