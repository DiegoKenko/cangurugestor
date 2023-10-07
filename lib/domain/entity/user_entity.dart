import 'package:cangurugestor/const/enum/enum_classe.dart';
import 'package:cangurugestor/domain/entity/pessoa_entity.dart';

class LoginEntity {
  LoginEntity(
    this.docId,
    this.uid,
    this.email,
    this.funcao,
    this.funcaoId,
  );
  String docId = '';
  String uid = '';
  String email = '';
  EnumClasse funcao = EnumClasse.naoDefinido;
  String funcaoId = '';

  LoginEntity.fromPessoa(PessoaEntity pessoa, {EnumClasse? classe}) {
    email = pessoa.email;
    if (classe == EnumClasse.gestor) {
      funcao = EnumClasse.gestor;
    } else if (classe == EnumClasse.responsavel) {
      funcao = EnumClasse.responsavel;
    } else if (classe == EnumClasse.cuidador) {
      funcao = EnumClasse.cuidador;
    } else {
      funcao = EnumClasse.naoDefinido;
    }
    funcaoId = pessoa.id;
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'funcao': funcao.collection,
      'funcaoId': funcaoId,
    };
  }

  LoginEntity.fromMap(Map<String, dynamic> map) {
    uid = map['uid'] ?? '';
    email = map['email'] ?? '';
    funcao = map['funcao'] ?? EnumClasse.naoDefinido;
    funcaoId = map['funcaoId'] ?? ' ';
  }

  bool get _isGestor => funcao == EnumClasse.gestor;
  bool get _isResponsavel => funcao == EnumClasse.responsavel;
  bool get _isCuidador => funcao == EnumClasse.cuidador;

  bool get editaPaciente => _isGestor;
  bool get editaResponsavel => _isGestor;
  bool get editaCuidador => _isGestor;
  bool get editaMedicamento => _isGestor;
  bool get editaAtividade => _isGestor;
  bool get editaConsulta => _isGestor;
  bool get criaTarefa => _isGestor;
  bool get realizaTarefa => _isCuidador;
  bool get gerarRelatorioCuidador => _isGestor || _isResponsavel;
}
