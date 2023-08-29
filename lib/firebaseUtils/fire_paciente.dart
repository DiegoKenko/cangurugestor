import 'package:cangurugestor/enum/enum_tarefa.dart';
import 'package:cangurugestor/model/atividade.dart';
import 'package:cangurugestor/model/consulta.dart';
import 'package:cangurugestor/model/cuidador.dart';
import 'package:cangurugestor/model/medicamento.dart';
import 'package:cangurugestor/model/paciente.dart';
import 'package:cangurugestor/model/tarefa.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class FirestorePaciente {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<Paciente> create(Paciente paciente) async {
    var doc = await firestore.collection('pacientes').add(paciente.toMap());
    paciente.id = doc.id;
    return paciente;
  }

  Future<Paciente> get(String idPaciente) async {
    Paciente paciente = Paciente();
    if (idPaciente.isNotEmpty) {
      await firestore
          .collection('pacientes')
          .doc(idPaciente)
          .get()
          .then((value) {
        if (value.exists) {
          return Paciente.fromMap(value.data()!);
        }
      });
    }
    throw paciente;
  }

  Future<void> update(Paciente paciente) async {
    if (paciente.id.isEmpty) {
      return;
    }
    await firestore
        .collection('pacientes')
        .doc(paciente.id)
        .update(paciente.toMap());
  }

  Future<void> excluirPaciente(
    Paciente paciente,
  ) async {
    firestore.collection('pacientes').doc(paciente.id).delete();
  }

  Future<List<Tarefa>> todasTarefasPaciente(
    String idPaciente,
    EnumTarefa enumTarefa,
  ) async {
    List<Tarefa> tarefas = [];
    // Busca proximas tarefas abertas
    await firestore
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

  Future<List<Medicamento>> todosMedicamentosPaciente(Paciente paciente) async {
    var doc = await firestore
        .collection('pacientes')
        .doc(paciente.id)
        .collection('medicamentos')
        .get();
    if (doc.docs.isNotEmpty) {
      return doc.docs.map((e) {
        Medicamento medicamento = Medicamento.fromMap(e.data());
        medicamento.id = e.id;
        return medicamento;
      }).toList();
    } else {
      return [];
    }
  }

  Future<List<Atividade>> todasAtividadesPaciente(Paciente paciente) async {
    var doc = await firestore
        .collection('pacientes')
        .doc(paciente.id)
        .collection('atividades')
        .get();
    if (doc.docs.isNotEmpty) {
      return doc.docs.map((e) {
        Atividade atividade = Atividade.fromMap(e.data());
        atividade.id = e.id;
        return atividade;
      }).toList();
    } else {
      return [];
    }
  }

  Future<List<Consulta>> todasConsultasPaciente(Paciente paciente) async {
    var doc = await firestore
        .collection('pacientes')
        .doc(paciente.id)
        .collection('consultas')
        .get();
    if (doc.docs.isNotEmpty) {
      return doc.docs.map((e) {
        Consulta consulta = Consulta.fromMap(e.data());
        consulta.id = e.id;
        return consulta;
      }).toList();
    } else {
      return [];
    }
  }

  Future<List<Cuidador>> todosCuidadoresPaciente(Paciente paciente) async {
    List<Cuidador> cuidadores = [];
    if (paciente.id.isEmpty || paciente.idCuidadores.isEmpty) {
      return cuidadores;
    } else {
      var doc = await firestore.collection('pacientes').doc(paciente.id).get();
      Paciente p = Paciente.fromMap(doc.data()!);
      for (var element in p.idCuidadores) {
        var docCuidador =
            await firestore.collection('cuidadores').doc(element).get();
        Cuidador cuidador = Cuidador.fromMap(docCuidador.data()!);
        cuidador.id = docCuidador.id;
        cuidadores.add(cuidador);
      }
      return cuidadores;
    }
  }
}
