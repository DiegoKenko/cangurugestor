import 'package:cangurugestor/classes/tarefa.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreTarefa {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  void criaTarefas(String idPaciente, List<Tarefa> tarefas) async {
    for (var tarefa in tarefas) {
      await firestore
          .collection('pacientes')
          .doc(idPaciente)
          .collection('tarefas')
          .add(tarefa.toMap());
    }
  }

  void excluirTarefa(String idPaciente, String idTarefa) async {
    firestore
        .collection('pacientes')
        .doc(idPaciente)
        .collection('tarefas')
        .doc(idTarefa)
        .delete();
  }

  Stream<List<Tarefa>> getTarefasMedicamento(
      String idMedicamento, String idPaciente,
      {bool concluida = false}) {
    return firestore
        .collection('pacientes')
        .doc(idPaciente)
        .collection('tarefas')
        .where('tipo', isEqualTo: 'medicamento')
        .where('idTipo', isEqualTo: idMedicamento)
        .where('concluida', isEqualTo: false)
        .where('dateTime', isGreaterThanOrEqualTo: DateTime.now())
        .snapshots()
        .map((QuerySnapshot event) =>
            event.docs.map((DocumentSnapshot documentSnapshot) {
              Tarefa tarefa = Tarefa.fromMap(
                  documentSnapshot.data() as Map<String, dynamic>);
              tarefa.id = documentSnapshot.id;
              return tarefa;
            }).toList());
  }

  Stream<List<Tarefa>> getTarefasAtividade(
      String idAtividade, String idPaciente,
      {bool concluida = false}) {
    return firestore
        .collection('pacientes')
        .doc(idPaciente)
        .collection('tarefas')
        .where('tipo', isEqualTo: 'atividade')
        .where('idTipo', isEqualTo: idAtividade)
        .where('concluida', isEqualTo: false)
        .where('dateTime', isGreaterThanOrEqualTo: DateTime.now())
        .snapshots()
        .map((QuerySnapshot event) =>
            event.docs.map((DocumentSnapshot documentSnapshot) {
              Tarefa tarefa = Tarefa.fromMap(
                  documentSnapshot.data() as Map<String, dynamic>);
              tarefa.id = documentSnapshot.id;
              return tarefa;
            }).toList());
  }

  Stream<List<Tarefa>> getTarefasConsulta(String idConsulta, String idPaciente,
      {bool concluida = false}) {
    return firestore
        .collection('pacientes')
        .doc(idPaciente)
        .collection('tarefas')
        .where('tipo', isEqualTo: 'consulta')
        .where('idTipo', isEqualTo: idConsulta)
        .where('concluida', isEqualTo: false)
        .where('dateTime', isGreaterThanOrEqualTo: DateTime.now())
        .snapshots()
        .map((QuerySnapshot event) =>
            event.docs.map((DocumentSnapshot documentSnapshot) {
              Tarefa tarefa = Tarefa.fromMap(
                  documentSnapshot.data() as Map<String, dynamic>);
              tarefa.id = documentSnapshot.id;
              return tarefa;
            }).toList());
  }

  Stream<List<Tarefa>> getTarefasTodas(String idPaciente) {
    return firestore
        .collection('pacientes')
        .doc(idPaciente)
        .collection('tarefas')
        .orderBy('dateTime')
        .snapshots()
        .map((event) => event.docs.map((e) {
              var tarefa = Tarefa.fromMap(e.data());
              tarefa.id = e.id;
              return tarefa;
            }).toList());
  }

  Future<void> atualizarTarefaPaciente(Tarefa tarefa, String idPaciente) async {
    await firestore
        .collection('pacientes')
        .doc(idPaciente)
        .collection('tarefas')
        .doc(tarefa.id)
        .update(tarefa.toMap());
  }
}
