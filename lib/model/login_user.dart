import 'package:cangurugestor/model/cuidador.dart';
import 'package:cangurugestor/model/gestor.dart';
import 'package:cangurugestor/model/responsavel.dart';

class LoginUser {
  String doc = '';
  String funcao = '';
  String senha = '';
  String email = '';
  bool ativo = false;

  LoginUser.fromGestor(Gestor gestor) {
    doc = gestor.id;
    funcao = 'gestor';
    email = gestor.email;
    ativo = gestor.ativo;
  }
  LoginUser.fromResponsavel(Responsavel responsavel) {
    doc = responsavel.id;
    funcao = 'responsavel';
    email = responsavel.email;
    ativo = responsavel.ativo;
  }

  LoginUser.fromCuidador(Cuidador cuidador) {
    doc = cuidador.id;
    funcao = 'cuidador';
    email = cuidador.email;
    ativo = cuidador.ativo;
  }

  LoginUser.fromMap(Map<String, dynamic> map) {
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
