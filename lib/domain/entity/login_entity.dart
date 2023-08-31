import 'package:cangurugestor/const/enum/enum_classe.dart';
import 'package:cangurugestor/domain/entity/cuidador_entity.dart';
import 'package:cangurugestor/domain/entity/gestor_entity.dart';
import 'package:cangurugestor/domain/entity/pessoa_entity.dart';
import 'package:cangurugestor/domain/entity/responsavel_entity.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginEntity {
  LoginEntity();
  LoginEntity.init(
    this.pessoa,
    this.user,
  );
  User? user;
  PessoaEntity pessoa = PessoaEntity();

  EnumClasse get classe {
    if (pessoa is GestorEntity) {
      return EnumClasse.gestor;
    } else if (pessoa is CuidadorEntity) {
      return EnumClasse.cuidador;
    } else if (pessoa is ResponsavelEntity) {
      return EnumClasse.responsavel;
    } else {
      return EnumClasse.naoDefinido;
    }
  }

  bool get _isGestor => classe == EnumClasse.gestor;
  bool get _isResponsavel => classe == EnumClasse.responsavel;
  bool get _isCuidador => classe == EnumClasse.cuidador;

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
