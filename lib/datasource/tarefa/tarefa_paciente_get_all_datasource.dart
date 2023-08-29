import 'package:cangurugestor/enum/enum_tarefa.dart';
import 'package:cangurugestor/global.dart';
import 'package:cangurugestor/model/paciente.dart';
import 'package:cangurugestor/model/tarefa.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TarefaPacienteGetAllDatasource {
  Future<List<Tarefa>> todasTarefasItem(
    Paciente paciente,
    EnumTarefa tipo,
    String idItem,
  ) async {
    List<Tarefa> tarefas = [];
    QuerySnapshot querySnapshot = await getIt<FirebaseFirestore>()
        .collection('pacientes')
        .doc(paciente.id)
        .collection('tarefas')
        .where('tipo', isEqualTo: tipo.name)
        .where('idTipo', isEqualTo: idItem)
        .orderBy('dateTime')
        .get();
    for (var documentSnapshot in querySnapshot.docs) {
      Tarefa tarefa =
          Tarefa.fromMap(documentSnapshot.data() as Map<String, dynamic>);
      tarefa.id = documentSnapshot.id;
      tarefas.add(tarefa);
    }
    return tarefas;
  }
}
