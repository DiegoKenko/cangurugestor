import 'package:cangurugestor/model/paciente.dart';
import 'package:cangurugestor/model/tarefa.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreTarefa {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> insert(Paciente paciente, Tarefa tarefa) async {
    if (paciente.id.isNotEmpty) {
      await firestore
          .collection('pacientes')
          .doc(paciente.id)
          .collection('tarefas')
          .add(tarefa.toMap());
    }
  }

  Future<void> update(Paciente paciente, Tarefa tarefa) async {
    if (paciente.id.isNotEmpty && tarefa.id.isNotEmpty) {
      await firestore
          .collection('pacientes')
          .doc(paciente.id)
          .collection('tarefas')
          .doc(tarefa.id)
          .update(tarefa.toMap());
    }
  }

  void criaMultiplasTarefas(Paciente paciente, List<Tarefa> tarefas) async {
    for (var tarefa in tarefas) {
      await firestore
          .collection('pacientes')
          .doc(paciente.id)
          .collection('tarefas')
          .add(tarefa.toMap());
    }
  }

  void delete(String idPaciente, String idTarefa) async {
    firestore
        .collection('pacientes')
        .doc(idPaciente)
        .collection('tarefas')
        .doc(idTarefa)
        .delete();
  }

  Future<List<Tarefa>> todasTarefasItem(
      Paciente paciente, String tipo, String idItem) async {
    List<Tarefa> tarefas = [];
    QuerySnapshot querySnapshot = await firestore
        .collection('pacientes')
        .doc(paciente.id)
        .collection('tarefas')
        .where('tipo', isEqualTo: tipo)
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

  Future<void> atualizarTarefaPaciente(Tarefa tarefa, Paciente paciente) async {
    await firestore
        .collection('pacientes')
        .doc(paciente.id)
        .collection('tarefas')
        .doc(tarefa.id)
        .update(tarefa.toMap());
  }
}
