import 'package:cangurugestor/domain/entity/cuidador.dart';
import 'package:cangurugestor/domain/entity/gestor.dart';
import 'package:cangurugestor/domain/entity/paciente.dart';
import 'package:cangurugestor/domain/entity/responsavel.dart';

class RelatorioGestorAcessos {
  GestorEntity gestor;
  List<CuidadorEntity> cuidadores = [];
  List<ResponsavelEntity> clientes = [];
  List<PacienteEntity> pacientes = [];

  RelatorioGestorAcessos(this.gestor);
}
