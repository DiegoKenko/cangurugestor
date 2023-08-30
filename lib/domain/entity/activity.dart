import 'package:cangurugestor/const/enum/enum_atividade.dart';
import 'package:cangurugestor/const/enum/enum_classe.dart';

class ActivityEntity {
  String userId = '';
  EnumClasse classe = EnumClasse.cuidador;
  String id = '';
  String activityId = '';
  EnumActivity activityName = EnumActivity.nenhum;
  String activityDescription = '';
  String activityDate = '';
  String activityTime = '';
  DateTime activityDateTime = DateTime.now();

  ActivityEntity({
    this.userId = '',
    this.activityId = '',
    this.activityName = EnumActivity.nenhum,
    this.activityDescription = '',
    this.activityDate = '',
    this.activityTime = '',
  });

  ActivityEntity.fromJson(Map<String, dynamic> json) {
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
