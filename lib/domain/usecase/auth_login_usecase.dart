import 'package:cangurugestor/datasource/cuidador/cuidador_create_datasource.dart';
import 'package:cangurugestor/datasource/gestor/gestor_create_datasource.dart';
import 'package:cangurugestor/datasource/login/login_autenticar_datasource.dart';
import 'package:cangurugestor/datasource/login/login_create_datasource.dart';
import 'package:cangurugestor/datasource/responsavel/responsavel_create_datasource.dart';
import 'package:cangurugestor/domain/entity/cuidador_entity.dart';
import 'package:cangurugestor/domain/entity/default_error_entity.dart';
import 'package:cangurugestor/domain/entity/gestor_entity.dart';
import 'package:cangurugestor/domain/entity/pessoa_entity.dart';
import 'package:cangurugestor/domain/entity/responsavel_entity.dart';
import 'package:cangurugestor/domain/entity/user_entity.dart';
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

  Future<Result<PessoaEntity, DefaultErrorEntity>> call(
      PessoaEntity pessoa,) async {
    await _authDatasource(pessoa.email).fold(
      (success) {
        return pessoa = success;
      },
      (error) {},
    );

    if (pessoa.id.isEmpty) {
      pessoa = await _criarPessoaFuncao(pessoa);
      if (pessoa.id.isEmpty) {
        return Failure(DefaultErrorEntity('message'));
      } else {
        return pessoa.toSuccess();
      }
    } else {
      return pessoa.toSuccess();
    }
  }

  Future<PessoaEntity> _criarPessoaFuncao(PessoaEntity pessoa) async {
    if (pessoa is CuidadorEntity) {
      await _cuidadorCreateDatasource(pessoa).fold(
        (success) {
          pessoa = success;
        },
        (error) {},
      );
    } else if (pessoa is ResponsavelEntity) {
      await _responsavelCreateDatasource(pessoa).fold(
        (success) {
          pessoa = success;
        },
        (error) {},
      );
    } else if (pessoa is GestorEntity) {
      await _gestorCreateDatasource(pessoa).fold(
        (success) {
          pessoa = success;
        },
        (error) {},
      );

      await _criarPessoaLogin(UserEntity.fromPessoa(pessoa));
    }
    return pessoa;
  }

  Future<UserEntity?> _criarPessoaLogin(UserEntity user) async {
    return await _loginCreateDatasource(user).fold(
      (success) => success,
      (error) => null,
    );
  }
}
