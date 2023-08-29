import 'package:cangurugestor/enum/enum_tarefa.dart';
import 'package:cangurugestor/global.dart';
import 'package:cangurugestor/model/tarefa.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class PacienteTarefaGetAllDatasource {
  Future<List<Tarefa>> todasTarefasPaciente(
    String idPaciente,
    EnumTarefa enumTarefa,
  ) async {
    List<Tarefa> tarefas = [];
    // Busca proximas tarefas abertas
    await getIt<FirebaseFirestore>()
        .collection('pacientes')
        .doc(idPaciente)
        .collection('tarefas')
        .where('tipo', isEqualTo: enumTarefa.name)
        .where(
          'date',
          isEqualTo: DateFormat('dd/MM/yyyy').format(DateTime.now()),
        )
        .where('concluida', isEqualTo: false)
        .orderBy('dateTime')
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        for (var element in value.docs) {
          tarefas.add(Tarefa.fromMap(element.data()));
          tarefas.last.id = element.id;
        }
      }
    });
    return tarefas;
  }
}
