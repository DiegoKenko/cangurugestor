import 'package:cangurugestor/model/cuidador.dart';
import 'package:cangurugestor/model/gestor.dart';
import 'package:cangurugestor/model/paciente.dart';
import 'package:cangurugestor/model/responsavel.dart';

class RelatorioGestorAcessos {
  Gestor gestor;
  List<Cuidador> cuidadores = [];
  List<Responsavel> clientes = [];
  List<Paciente> pacientes = [];

  RelatorioGestorAcessos(this.gestor);
}
