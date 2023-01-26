import 'package:cangurugestor/model/cuidador.dart';
import 'package:cangurugestor/model/responsavel.dart';

class LoginUser {
  String id = '';
  String doc = '';
  String funcao = '';
  String colecao = '';
  String senha = '';
  String email = '';
  String cpf = '';
  bool ativo = false;

  LoginUser.fromResponsavel(Responsavel responsavel) {
    id = responsavel.id;
    doc = responsavel.id;
    funcao = 'responsavel';
    colecao = 'responsaveis';
    email = responsavel.email;
    cpf = responsavel.cpf;
    ativo = responsavel.ativo;
  }

  LoginUser.fromCuidador(Cuidador cuidador) {
    id = cuidador.id;
    doc = cuidador.id;
    funcao = 'cuidador';
    colecao = 'cuidadores';
    email = cuidador.email;
    cpf = cuidador.cpf;
    ativo = cuidador.ativo;
  }

  LoginUser.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    ativo = map['ativo'];
    colecao = map['colecao'];
    cpf = map['cpf'];
    doc = map['doc'];
    email = map['email'];
    funcao = map['funcao'];
    senha = map['senha'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'ativo': ativo,
      'colecao': colecao,
      'cpf': cpf,
      'doc': doc,
      'email': email,
      'funcao': funcao,
      'senha': senha,
    };
  }
}
