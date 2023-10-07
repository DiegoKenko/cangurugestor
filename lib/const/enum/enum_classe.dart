import 'package:flutter/foundation.dart';

enum EnumClasse { gestor, responsavel, cuidador, paciente, naoDefinido }

extension ClasseDescricao on EnumClasse {
  String get description => describeEnum(this);
  String get collection {
    switch (this) {
      case EnumClasse.gestor:
        return 'gestores';
      case EnumClasse.responsavel:
        return 'responsaveis';
      case EnumClasse.cuidador:
        return 'cuidadores';
      case EnumClasse.paciente:
        return 'pacientes';
      default:
        return 'erro';
    }
  }
}
