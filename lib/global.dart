import 'package:flutter/foundation.dart';

const int opcaoInclusao = 1;
const int opcaoAlteracao = 2;
const int opcaoVisualizacao = 3;
const int privilegioNenhum = 0;
const int privilegioGestor = 1;
const int privilegioResponsavel = 2;
const int privilegioCuidador = 3;

enum EnumIntervalo {
  minutos,
  horas,
  dias,
  semanas,
  meses,
}

enum EnumClasse {
  gestor,
  responsavel,
  cuidador,
  paciente,
  naoDefinido,
}

enum EnumTarefa {
  medicamento,
  atividade,
  consulta,
  nenhuma,
}

enum EnumFiltroDataTarefa {
  ontem,
  hoje,
  amanha,
  proxSemana,
}

enum EnumStatus { concluido, emAberto, nenhum }

extension TarefaDescricao on EnumTarefa {
  String get name => describeEnum(this);
  String get collection {
    switch (this) {
      case EnumTarefa.medicamento:
        return 'medicamento';
      case EnumTarefa.atividade:
        return 'atividade';
      case EnumTarefa.consulta:
        return 'consulta';
      default:
        return 'erro';
    }
  }
}

extension FrequenciaDescricao on EnumIntervalo {
  String get name => describeEnum(this);
  String get displayTitle {
    switch (this) {
      case EnumIntervalo.minutos:
        return 'minutos';
      case EnumIntervalo.horas:
        return 'horas';
      case EnumIntervalo.dias:
        return 'dias';
      case EnumIntervalo.semanas:
        return 'semanas';
      case EnumIntervalo.meses:
        return 'meses';
      default:
        return 'erro';
    }
  }
}

double enumIntervaloEmMinutos(Object enumEntry, double quant) {
  switch (enumEntry) {
    case EnumIntervalo.minutos:
      return quant;
    case EnumIntervalo.horas:
      return quant * 60;
    case EnumIntervalo.dias:
      return quant * 60 * 24;
    case EnumIntervalo.semanas:
      return quant * 60 * 24 * 7;
    case EnumIntervalo.meses:
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
