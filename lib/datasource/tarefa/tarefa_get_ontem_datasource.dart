import 'package:cangurugestor/const/global.dart';
import 'package:cangurugestor/domain/entity/paciente_entity.dart';
import 'package:cangurugestor/domain/entity/tarefa_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class TarefaGetOntemDatasource {
  Future<List<TarefaEntity>> call(PacienteEntity paciente) async {
    List<TarefaEntity> tarefas = [];
    var ref = await getIt<FirebaseFirestore>()
        .collection('pacientes')
        .doc(paciente.id)
        .collection('tarefas')
        .where(
          'date',
          isEqualTo: DateFormat('dd/MM/yyyy')
              .format(DateTime.now().subtract(const Duration(days: 1))),
        )
        .orderBy('dateTime')
        .get();

    for (var t in ref.docs) {
      TarefaEntity tarefa = TarefaEntity.fromMap(t.data());
      tarefa.id = t.id;
      tarefas.add(tarefa);
    }
    return tarefas;
  }
}
