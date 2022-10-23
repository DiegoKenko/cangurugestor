library canguru.global;

import 'package:cangurugestor/classes/cuidador.dart';
import 'package:cangurugestor/classes/gestor.dart';
import 'package:cangurugestor/classes/paciente.dart';
import 'package:cangurugestor/classes/responsavel.dart';

String idGestorGlobal = '';
String idResponsavelGlobal = '';
String idCuidadorGlobal = '';
String idPacienteGlobal = '';
Gestor? gestorAtual;
Cuidador? cuidadorAtual;
Paciente? pacienteAtual;
Responsavel? responsavelAtual;
const int opcaoInclusao = 1;
const int opcaoAlteracao = 2;
const int opcaoVisualizacao = 3;
const int privilegioGestor = 1;
const int privilegioResponsavel = 2;
const int privilegioCuidador = 3;

enum EnumFrequencia {
  minutos,
  horas,
  dias,
  semanas,
  meses,
  nenhum,
}

enum EnumClasse {
  gestor,
  responsavel,
  cuidador,
  paciente,
}

enum EnumTarefa { medicamento, atividade, consulta, nenhuma }

extension FrequenciaDescricao on EnumFrequencia {
  String get name => describeEnum(this);
  String get displayTitle {
    switch (this) {
      case EnumFrequencia.minutos:
        return 'minutos';
      case EnumFrequencia.horas:
        return 'horas';
      case EnumFrequencia.dias:
        return 'dias';
      case EnumFrequencia.semanas:
        return 'semanas';
      case EnumFrequencia.meses:
        return 'meses';
      default:
        return 'erro';
    }
  }
}

String describeEnum(Object enumEntry) {
  final String description = enumEntry.toString();
  final int indexOfDot = description.indexOf('.');
  assert(indexOfDot != -1 && indexOfDot < description.length - 1);
  return description.substring(indexOfDot + 1);
}

double enumFrequenciaEmMinutos(Object enumEntry, double quant) {
  switch (enumEntry) {
    case EnumFrequencia.minutos:
      return quant;
    case EnumFrequencia.horas:
      return quant * 60;
    case EnumFrequencia.dias:
      return quant * 60 * 24;
    case EnumFrequencia.semanas:
      return quant * 60 * 24 * 7;
    case EnumFrequencia.meses:
      return quant * 60 * 24 * 30;
    default:
      return quant;
  }
}

Enum tipoTarefaEnum(String tipo) {
  switch (tipo) {
    case 'Medicamento':
      return EnumTarefa.medicamento;
    case 'Atividade':
      return EnumTarefa.atividade;
    case 'Consulta':
      return EnumTarefa.consulta;
    default: //não deveria chegar aqui
      return EnumTarefa.medicamento;
  }
}
