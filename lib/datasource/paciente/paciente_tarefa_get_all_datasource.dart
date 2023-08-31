import 'package:cangurugestor/const/enum/enum_tarefa.dart';
import 'package:cangurugestor/const/global.dart';
import 'package:cangurugestor/domain/entity/tarefa_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class PacienteTarefaGetAllDatasource {
  Future<List<TarefaEntity>> todasTarefasPaciente(
    String idPaciente,
    EnumTarefa enumTarefa,
  ) async {
    List<TarefaEntity> tarefas = [];
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
          tarefas.add(TarefaEntity.fromMap(element.data()));
          tarefas.last.id = element.id;
        }
      }
    });
    return tarefas;
  }
}
