import 'package:cangurugestor/domain/entity/activity.dart';
import 'package:cangurugestor/const/enum/enum_atividade.dart';

class TarefaActivityEntity extends ActivityEntity {
  String tarefaId = '';
  String pacienteId = '';
  String tarefaDescription = '';
  String pacienteName = '';

  TarefaActivityEntity({
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

  TarefaActivityEntity.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
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
