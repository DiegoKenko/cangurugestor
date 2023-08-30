import 'package:flutter/foundation.dart';

enum EnumTarefa { medicamento, atividade, consulta, nenhuma }

enum EnumFiltroDataTarefa { ontem, hoje, amanha, proxSemana, todos }

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

tipoTarefaEnum(String tipo) {
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
