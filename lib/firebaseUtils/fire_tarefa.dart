import 'package:cangurugestor/model/paciente.dart';
import 'package:cangurugestor/model/tarefa.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

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

  Future<void> criaMultiplasTarefas(
      Paciente paciente, List<Tarefa> tarefas) async {
    for (var tarefa in tarefas) {
      await firestore
          .collection('pacientes')
          .doc(paciente.id)
          .collection('tarefas')
          .add(tarefa.toMap());
    }
  }

  Future<void> delete(String idPaciente, String idTarefa) async {
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

  Future<void> atualizarTarefaPaciente(Tarefa tarefa, Paciente paciente) async {
    await firestore
        .collection('pacientes')
        .doc(paciente.id)
        .collection('tarefas')
        .doc(tarefa.id)
        .update(tarefa.toMap());
  }

  Future<List<Tarefa>> todasTarefasOntem(Paciente paciente) async {
    List<Tarefa> tarefas = [];
    var ref = await firestore
        .collection('pacientes')
        .doc(paciente.id)
        .collection('tarefas')
        .where('date',
            isEqualTo: DateFormat('dd/MM/yyyy')
                .format(DateTime.now().subtract(const Duration(days: 1))))
        .orderBy('dateTime')
        .get();

    for (var t in ref.docs) {
      Tarefa tarefa = Tarefa.fromMap(t.data());
      tarefa.id = t.id;
      tarefas.add(tarefa);
    }
    return tarefas;
  }

  Future<List<Tarefa>> todasTarefasHoje(Paciente paciente) async {
    List<Tarefa> tarefas = [];
    var ref = await firestore
        .collection('pacientes')
        .doc(paciente.id)
        .collection('tarefas')
        .where('date',
            isEqualTo: DateFormat('dd/MM/yyyy').format(DateTime.now()))
        .orderBy('dateTime')
        .get();

    for (var t in ref.docs) {
      Tarefa tarefa = Tarefa.fromMap(t.data());
      tarefa.id = t.id;
      tarefas.add(tarefa);
    }
    return tarefas;
  }

  Future<List<Tarefa>> todasTarefasAmanha(Paciente paciente) async {
    List<Tarefa> tarefas = [];
    var ref = await firestore
        .collection('pacientes')
        .doc(paciente.id)
        .collection('tarefas')
        .where('date',
            isEqualTo: DateFormat('dd/MM/yyyy')
                .format(DateTime.now().add(const Duration(days: 1))))
        .orderBy('dateTime')
        .get();

    for (var t in ref.docs) {
      Tarefa tarefa = Tarefa.fromMap(t.data());
      tarefa.id = t.id;
      tarefas.add(tarefa);
    }
    return tarefas;
  }

  Future<List<Tarefa>> todasTarefasSemana(Paciente paciente) async {
    List<Tarefa> tarefas = [];
    var ref = await firestore
        .collection('pacientes')
        .doc(paciente.id)
        .collection('tarefas')
        .where('date',
            isGreaterThan: DateFormat('dd/MM/yyyy')
                .format(DateTime.now().add(const Duration(days: 1))),
            isLessThanOrEqualTo: DateFormat('dd/MM/yyyy')
                .format(DateTime.now().add(const Duration(days: 7))))
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
