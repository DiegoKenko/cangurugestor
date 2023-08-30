enum EnumActivity { tarefa, login, nenhum }

extension EnumActivityExtension on EnumActivity {
  String get name {
    switch (this) {
      case EnumActivity.tarefa:
        return 'tarefa';
      case EnumActivity.login:
        return 'login';
      default:
        return 'nenhum';
    }
  }
}
