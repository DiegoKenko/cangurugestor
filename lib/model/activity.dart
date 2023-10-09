import 'package:cangurugestor/global.dart';

class Activity {
  String userId = '';
  EnumClasse classe = EnumClasse.cuidador;
  String id = '';
  String activityId = '';
  EnumActivity activityName = EnumActivity.nenhum;
  String activityDescription = '';
  String activityDate = '';
  String activityTime = '';
  DateTime activityDateTime = DateTime.now();

  Activity({
    this.userId = '',
    this.activityId = '',
    this.activityName = EnumActivity.nenhum,
    this.activityDescription = '',
    this.activityDate = '',
    this.activityTime = '',
  });

  Activity.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    activityName = EnumActivity.values.firstWhere(
      (element) => element.name == json['name'],
      orElse: () => EnumActivity.nenhum,
    );
    activityDescription = json['description'];
    activityDate = json['date'];
    activityTime = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    data['name'] = activityName.name;
    data['description'] = activityDescription;
    data['date'] = activityDate;
    data['time'] = activityTime;
    return data;
  }
}

class LoginActivity extends Activity {
  LoginActivity({
    String userId = '',
    String activityId = '',
    String activityDate = '',
    String activityTime = '',
  }) : super(
          userId: userId,
          activityId: activityId,
          activityName: EnumActivity.login,
          activityDescription: 'login realizado',
          activityDate: activityDate,
          activityTime: activityTime,
        );

  LoginActivity.fromJson(Map<String, dynamic> json) : super.fromJson(json);

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    return data;
  }
}

class TarefaActivity extends Activity {
  String tarefaId = '';
  String pacienteId = '';
  String tarefaDescription = '';
  String pacienteName = '';

  TarefaActivity({
    this.tarefaId = '',
    this.pacienteId = '',
    this.tarefaDescription = '',
    this.pacienteName = '',
    String userId = '',
    String activityId = '',
    String activityDescription = '',
    String activityDate = '',
    String activityTime = '',
  }) : super(
          userId: userId,
          activityId: activityId,
          activityName: EnumActivity.tarefa,
          activityDescription: 'tarefa realizada',
          activityDate: activityDate,
          activityTime: activityTime,
        );

  TarefaActivity.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    tarefaId = json['tarefaId'];
    tarefaDescription = json['tarefaDescription'];
    pacienteId = json['pacienteId'];
    pacienteName = json['pacienteName'];
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    data['tarefaId'] = tarefaId;
    data['pacienteId'] = pacienteId;
    data['tarefaDescription'] = tarefaDescription;
    data['pacienteName'] = pacienteName;

    return data;
  }
}
