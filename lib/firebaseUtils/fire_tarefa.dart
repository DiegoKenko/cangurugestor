import 'package:cangurugestor/global.dart';
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

  Future<List<Tarefa>> todasTarefasPeriodo(
      Paciente paciente, EnumFiltroDataTarefa filtro) async {
    List<Tarefa> tarefas = [];
    final DateTime now = DateTime.now();
    final DateFormat dateFormat = DateFormat('dd/MM/yyy');
    final String nowString = DateTime.now().toIso8601String();
    CollectionReference<Map<String, dynamic>> collectionReference = firestore
        .collection('pacientes')
        .doc(paciente.id)
        .collection('tarefas');
    QuerySnapshot<Map<String, dynamic>> doc;

    switch (filtro) {
      case EnumFiltroDataTarefa.ontem:
        doc = await collectionReference
            .where(
              'date',
              isEqualTo: dateFormat.format(
                now.add(
                  const Duration(days: 1),
                ),
              ),
            )
            .get();
        break;
      case EnumFiltroDataTarefa.hoje:
        doc = await collectionReference
            .where(
              'date',
              isEqualTo: dateFormat.format(now),
            )
            .get();
        break;
      case EnumFiltroDataTarefa.estaSemana:
        doc = await collectionReference
            .where(
              'date',
              isGreaterThan: dateFormat.format(now),
            )
            .where(
              'date',
              isLessThanOrEqualTo: dateFormat.format(
                now.add(
                  const Duration(days: 7),
                ),
              ),
            )
            .get();
        break;
      case EnumFiltroDataTarefa.amanha:
        doc = await collectionReference
            .where(
              'date',
              isEqualTo: dateFormat.format(
                now.add(
                  const Duration(days: 1),
                ),
              ),
            )
            .get();
        break;
      default:
        doc = await collectionReference
            .where(
              'date',
              isEqualTo: dateFormat.format(now),
            )
            .get();
    }

    tarefas = doc.docs.map((e) {
      Tarefa tarefa = Tarefa.fromMap(e.data());
      tarefa.id = e.id;
      return tarefa;
    }).toList();
    return tarefas;
  }
}
