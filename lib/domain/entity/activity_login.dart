import 'package:cangurugestor/domain/entity/activity.dart';
import 'package:cangurugestor/const/enum/enum_atividade.dart';

class LoginActivityEntity extends ActivityEntity {
  LoginActivityEntity({
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

  LoginActivityEntity.fromJson(Map<String, dynamic> json)
      : super.fromJson(json);

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    return data;
  }
}
