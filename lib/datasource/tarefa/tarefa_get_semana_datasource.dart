import 'package:cangurugestor/const/global.dart';
import 'package:cangurugestor/domain/entity/paciente.dart';
import 'package:cangurugestor/domain/entity/tarefa.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class TarefaGetSemanaDatasource {
  Future<List<TarefaEntity>> call(PacienteEntity paciente) async {
    List<TarefaEntity> tarefas = [];
    var ref = await getIt<FirebaseFirestore>()
        .collection('pacientes')
        .doc(paciente.id)
        .collection('tarefas')
        .where(
          'date',
          isGreaterThan: DateFormat('dd/MM/yyyy')
              .format(DateTime.now().add(const Duration(days: 1))),
          isLessThanOrEqualTo: DateFormat('dd/MM/yyyy')
              .format(DateTime.now().add(const Duration(days: 7))),
        )
        .orderBy('date')
        .get();

    for (var t in ref.docs) {
      TarefaEntity tarefa = TarefaEntity.fromMap(t.data());
      tarefa.id = t.id;
      tarefas.add(tarefa);
    }
    return tarefas;
  }
}
