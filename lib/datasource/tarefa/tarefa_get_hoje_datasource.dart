import 'package:cangurugestor/global.dart';
import 'package:cangurugestor/model/paciente.dart';
import 'package:cangurugestor/model/tarefa.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class TarefaGetHojeDatasource {
  Future<List<Tarefa>> todasTarefasHoje(Paciente paciente) async {
    List<Tarefa> tarefas = [];
    var ref = await getIt<FirebaseFirestore>()
        .collection('pacientes')
        .doc(paciente.id)
        .collection('tarefas')
        .where(
          'date',
          isEqualTo: DateFormat('dd/MM/yyyy').format(DateTime.now()),
        )
        .orderBy('dateTime')
        .get();

    for (var t in ref.docs) {
      Tarefa tarefa = Tarefa.fromMap(t.data());
      tarefa.id = t.id;
      tarefas.add(tarefa);
    }
    return tarefas;
  }
}
