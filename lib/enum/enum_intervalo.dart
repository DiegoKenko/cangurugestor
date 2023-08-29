import 'package:flutter/foundation.dart';

enum EnumIntervalo { minutos, horas, dias, semanas, meses }

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
