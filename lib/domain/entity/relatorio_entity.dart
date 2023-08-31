import 'package:cangurugestor/domain/entity/cuidador_entity.dart';
import 'package:cangurugestor/domain/entity/gestor_entity.dart';
import 'package:cangurugestor/domain/entity/paciente_entity.dart';
import 'package:cangurugestor/domain/entity/responsavel_entity.dart';

class RelatorioGestorAcessos {
  GestorEntity gestor;
  List<CuidadorEntity> cuidadores = [];
  List<ResponsavelEntity> clientes = [];
  List<PacienteEntity> pacientes = [];

  RelatorioGestorAcessos(this.gestor);
}
