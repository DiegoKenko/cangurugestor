import 'package:cangurugestor/const/enum/enum_classe.dart';
import 'package:cangurugestor/domain/entity/cuidador_entity.dart';
import 'package:cangurugestor/domain/entity/gestor_entity.dart';
import 'package:cangurugestor/domain/entity/pessoa_entity.dart';
import 'package:cangurugestor/domain/entity/responsavel_entity.dart';

class UserEntity {
  UserEntity(
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

  UserEntity.fromPessoa(PessoaEntity pessoa) {
    uid = pessoa.id;
    email = pessoa.email;
    if (pessoa is GestorEntity) {
      funcao = EnumClasse.gestor;
    } else if (pessoa is ResponsavelEntity) {
      funcao = EnumClasse.responsavel;
    } else if (pessoa is CuidadorEntity) {
      funcao = EnumClasse.cuidador;
    } else {
      funcao = EnumClasse.naoDefinido;
    }
    funcaoId = pessoa.id;
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'funcao': funcao,
      'funcaoId': funcaoId,
    };
  }

  UserEntity.fromMap(Map<String, dynamic> map) {
    uid = map['uid'];
    email = map['email'];
    funcao = map['funcao'];
    funcaoId = map['funcaoId'];
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
