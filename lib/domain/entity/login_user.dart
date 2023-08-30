import 'package:cangurugestor/domain/entity/cuidador.dart';
import 'package:cangurugestor/domain/entity/gestor.dart';
import 'package:cangurugestor/domain/entity/responsavel.dart';

class LoginUserEntity {
  String doc = '';
  String funcao = '';
  String senha = '';
  String email = '';
  bool ativo = false;

  LoginUserEntity.fromGestor(GestorEntity gestor) {
    doc = gestor.id;
    funcao = 'gestor';
    email = gestor.email;
    ativo = gestor.ativo;
  }
  LoginUserEntity.fromResponsavel(ResponsavelEntity responsavel) {
    doc = responsavel.id;
    funcao = 'responsavel';
    email = responsavel.email;
    ativo = responsavel.ativo;
  }

  LoginUserEntity.fromCuidador(CuidadorEntity cuidador) {
    doc = cuidador.id;
    funcao = 'cuidador';
    email = cuidador.email;
    ativo = cuidador.ativo;
  }

  LoginUserEntity.fromMap(Map<String, dynamic> map) {
    ativo = map['ativo'];
    doc = map['doc'];
    email = map['email'];
    funcao = map['funcao'];
    senha = map['senha'];
  }

  Map<String, dynamic> toMap() {
    return {
      'ativo': ativo,
      'doc': doc,
      'email': email,
      'funcao': funcao,
      'senha': senha,
    };
  }
}
