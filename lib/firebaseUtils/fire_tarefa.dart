import 'package:cangurugestor/classes/tarefa.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class FirestoreTarefa {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  criaTarefas(String idPaciente, List<Tarefa> tarefas) {
    for (var tarefa in tarefas) {
      firestore
          .collection('pacientes')
          .doc(idPaciente)
          .collection('tarefas')
          .add(tarefa.toMap());
    }
  }

  excluirTarefa(String idPaciente, String idTarefa) async {
    firestore
        .collection('pacientes')
        .doc(idPaciente)
        .collection('tarefas')
        .doc(idTarefa)
        .delete();
  }

  Future<List<Tarefa>> getTarefasMedicamento(
      String idMedicamento, String idPaciente,
      {bool concluida = false}) async {
    List<Tarefa> tarefas = [];
    if (idMedicamento.isEmpty || idPaciente.isEmpty) return tarefas;
    var value = await firestore
        .collection('pacientes')
        .doc(idPaciente)
        .collection('tarefas')
        .where('tipo', isEqualTo: 'medicamento')
        .where('idTipo', isEqualTo: idMedicamento)
        .where('concluida', isEqualTo: false)
        .where('date',
            isGreaterThanOrEqualTo:
                DateFormat('dd/MM/yyyy').format(DateTime.now()))
        .get();

    if (value.docs.isNotEmpty) {
      for (var element in value.docs) {
        tarefas.add(Tarefa.fromMap(element.data()));
        tarefas.last.id = element.id;
      }
    }
    return tarefas;
  }

  Future<List<Tarefa>> getTarefasAtividade(
      String idAtividade, String idPaciente,
      {bool concluida = false}) async {
    List<Tarefa> tarefas = [];
    if (idAtividade.isEmpty || idPaciente.isEmpty) return tarefas;
    var value = await firestore
        .collection('pacientes')
        .doc(idPaciente)
        .collection('tarefas')
        .where('tipo', isEqualTo: 'atividade')
        .where('idTipo', isEqualTo: idAtividade)
        .where('concluida', isEqualTo: false)
        .where('date',
            isGreaterThanOrEqualTo:
                DateFormat('dd/MM/yyyy').format(DateTime.now()))
        .get();

    if (value.docs.isNotEmpty) {
      for (var element in value.docs) {
        tarefas.add(Tarefa.fromMap(element.data()));
        tarefas.last.id = element.id;
      }
    }
    return tarefas;
  }

  Future<List<Tarefa>> getTarefasConsulta(String idConsulta, String idPaciente,
      {bool concluida = false}) async {
    List<Tarefa> tarefas = [];
    if (idConsulta.isEmpty || idPaciente.isEmpty) return tarefas;
    var value = await firestore
        .collection('pacientes')
        .doc(idPaciente)
        .collection('tarefas')
        .where('tipo', isEqualTo: 'consulta')
        .where('idTipo', isEqualTo: idConsulta)
        .where('concluida', isEqualTo: false)
        .where('date',
            isGreaterThanOrEqualTo:
                DateFormat('dd/MM/yyyy').format(DateTime.now()))
        .get();

    if (value.docs.isNotEmpty) {
      for (var element in value.docs) {
        tarefas.add(Tarefa.fromMap(element.data()));
        tarefas.last.id = element.id;
      }
    }
    return tarefas;
  }

  Future<List<Tarefa>> getTarefasTodas(String idPaciente) async {
    List<Tarefa> tarefas = [];
    // Busca proximas tarefas abertas
    await firestore
        .collection('pacientes')
        .doc(idPaciente)
        .collection('tarefas')
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
