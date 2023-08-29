import 'package:cangurugestor/global.dart';
import 'package:cangurugestor/model/paciente.dart';
import 'package:cangurugestor/model/tarefa.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class TarefaGetSemanaDatasource {
  Future<List<Tarefa>> todasTarefasSemana(Paciente paciente) async {
    List<Tarefa> tarefas = [];
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
      Tarefa tarefa = Tarefa.fromMap(t.data());
      tarefa.id = t.id;
      tarefas.add(tarefa);
    }
    return tarefas;
  }
}
