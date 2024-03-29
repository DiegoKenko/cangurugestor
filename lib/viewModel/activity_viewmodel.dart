import 'package:cangurugestor/firebaseUtils/fire_activity.dart';
import 'package:cangurugestor/model/activity.dart';
import 'package:cangurugestor/model/cuidador.dart';
import 'package:cangurugestor/model/paciente.dart';
import 'package:cangurugestor/model/pessoa.dart';
import 'package:cangurugestor/model/tarefa.dart';
import 'package:intl/intl.dart';

class ActivityViewModel {
  ActivityViewModel.login(Pessoa user) {
    LoginActivity activity = LoginActivity(
      userId: user.id,
      activityId: user.id,
      activityDate: DateFormat('dd/MM/yyyy').format(DateTime.now()),
      activityTime: DateFormat('HH:mm').format(DateTime.now()),
    );

    FirestoreActivity().addLoginActivity(activity);
  }

  ActivityViewModel.tarefaCuidador(
    Tarefa tarefa,
    Cuidador cuidador,
    Paciente paciente,
  ) {
    TarefaActivity activity = TarefaActivity(
      tarefaId: tarefa.id,
      pacienteId: paciente.id,
      userId: cuidador.id,
      activityDescription: 'realização da terefa',
      activityDate: DateFormat('dd/MM/yyyy').format(DateTime.now()),
      activityTime: DateFormat('HH:mm').format(DateTime.now()),
    );
    FirestoreActivity().addTarefaActivity(activity);
  }
}
