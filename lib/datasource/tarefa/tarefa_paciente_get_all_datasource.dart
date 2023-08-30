import 'package:cangurugestor/const/global.dart';
import 'package:cangurugestor/domain/entity/paciente.dart';
import 'package:cangurugestor/domain/entity/tarefa.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TarefaPacienteGetAllDatasource {
  Future<List<TarefaEntity>> call(
    PacienteEntity paciente,
  ) async {
    List<TarefaEntity> tarefas = [];
    QuerySnapshot querySnapshot = await getIt<FirebaseFirestore>()
        .collection('pacientes')
        .doc(paciente.id)
        .collection('tarefas')
        .orderBy('dateTime')
        .get();
    for (var documentSnapshot in querySnapshot.docs) {
      TarefaEntity tarefa =
          TarefaEntity.fromMap(documentSnapshot.data() as Map<String, dynamic>);
      tarefa.id = documentSnapshot.id;
      tarefas.add(tarefa);
    }
    return tarefas;
  }
}
