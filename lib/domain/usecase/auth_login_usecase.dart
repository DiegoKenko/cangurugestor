import 'package:cangurugestor/const/enum/enum_classe.dart';
import 'package:cangurugestor/datasource/cuidador/cuidador_create_datasource.dart';
import 'package:cangurugestor/datasource/cuidador/cuidador_get_datasource.dart';
import 'package:cangurugestor/datasource/gestor/gestor_create_datasource.dart';
import 'package:cangurugestor/datasource/gestor/gestor_get_datasource.dart';
import 'package:cangurugestor/datasource/login/login_autenticar_datasource.dart';
import 'package:cangurugestor/datasource/login/login_create_datasource.dart';
import 'package:cangurugestor/datasource/responsavel/responsavel_create_datasource.dart';
import 'package:cangurugestor/datasource/responsavel/responsavel_get_datasource.dart';
import 'package:cangurugestor/domain/entity/cuidador_entity.dart';
import 'package:cangurugestor/domain/entity/default_error_entity.dart';
import 'package:cangurugestor/domain/entity/gestor_entity.dart';
import 'package:cangurugestor/domain/entity/pessoa_entity.dart';
import 'package:cangurugestor/domain/entity/responsavel_entity.dart';
import 'package:cangurugestor/domain/entity/user_entity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:result_dart/result_dart.dart';

class AuthLoginUseCase {
  final LoginAuntenticarDatasource _authDatasource =
      LoginAuntenticarDatasource();
  final LoginCreateDatasource _loginCreateDatasource = LoginCreateDatasource();
  final CuidadorCreateDatasource _cuidadorCreateDatasource =
      CuidadorCreateDatasource();
  final GestorCreateDatasource _gestorCreateDatasource =
      GestorCreateDatasource();
  final ResponsavelCreateDatasource _responsavelCreateDatasource =
      ResponsavelCreateDatasource();
  final CuidadorGetDatasource cuidadorGetDatasource = CuidadorGetDatasource();
  final ResponsavelGetDatasource responsavelGetDatasource =
      ResponsavelGetDatasource();
  final GestorGetDatasource gestorGetDatasource = GestorGetDatasource();

  Future<Result<PessoaEntity, DefaultErrorEntity>> call({
    required User user,
    EnumClasse? classe,
  }) async {
    PessoaEntity? pessoa;
    await _authDatasource(user.email ?? '').fold(
      (success) {
        return pessoa = success;
      },
      (error) {},
    );
    if (pessoa == null) {
      if (classe != null) {
        await _criarRole(user, classe)
            .fold((success) {}, (error) => pessoa = null);
        if (pessoa != null) {
          await _criarLogin(pessoa!);
          return pessoa!.toSuccess();
        } else {
          return Failure(DefaultErrorEntity(''));
        }
      } else {
        return Failure(DefaultErrorEntity(''));
      }
    } else {
      return pessoa!.toSuccess();
    }
  }

  Future<Result<PessoaEntity, DefaultErrorEntity>> _criarRole(
    User user,
    EnumClasse classe,
  ) async {
    PessoaEntity? pessoa;
    if (classe == EnumClasse.cuidador) {
      await _cuidadorCreateDatasource(CuidadorEntity.fromUser(user)).fold(
        (success) => pessoa = CuidadorEntity.fromUser(user),
        (error) {},
      );
    } else if (classe == EnumClasse.responsavel) {
      await _responsavelCreateDatasource(ResponsavelEntity.fromUser(user)).fold(
        (success) => pessoa = ResponsavelEntity.fromUser(user),
        (error) {},
      );
    } else if (classe == EnumClasse.gestor) {
      await _gestorCreateDatasource(GestorEntity.fromUser(user)).fold(
        (success) => pessoa = GestorEntity.fromUser(user),
        (error) {},
      );
    }
    if (pessoa != null) {
      return pessoa!.toSuccess();
    } else {
      return Failure(DefaultErrorEntity(''));
    }
  }

  Future<LoginEntity?> _criarLogin(PessoaEntity pessoa) async {
    return await _loginCreateDatasource(LoginEntity.fromPessoa(pessoa)).fold(
      (success) => success,
      (error) => null,
    );
  }
}
