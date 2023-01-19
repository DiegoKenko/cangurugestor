import 'package:cangurugestor/global.dart';
import 'package:cangurugestor/model/atividade.dart';
import 'package:cangurugestor/model/consulta.dart';
import 'package:cangurugestor/model/cuidador.dart';
import 'package:cangurugestor/model/medicamento.dart';
import 'package:cangurugestor/model/paciente.dart';
import 'package:cangurugestor/model/responsavel.dart';
import 'package:cangurugestor/model/tarefa.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class FirestorePaciente {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<Paciente> buscarPaciente(String idPaciente) async {
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

  Future<Paciente> incluirPaciente(
      Responsavel responsavel, Paciente paciente) async {
    var doc = await firestore.collection('pacientes').add(paciente.toMap());
    paciente.id = doc.id;

    if (!responsavel.idPacientes.contains(paciente.id)) {
      await firestore.collection('responsaveis').doc(responsavel.id).update({
        'idPacientes': FieldValue.arrayUnion([paciente.id])
      });
    }

    return paciente;
  }

  void atualizarPaciente(Paciente paciente) {
    firestore.collection('pacientes').doc(paciente.id).get().then(
      (snapshot) {
        if (snapshot.exists) {
          snapshot.reference.update(paciente.toMap());
        }
      },
    );
  }

  Future<void> excluirPaciente(
      Responsavel responsavel, Paciente paciente) async {
    firestore.collection('responsaveis').doc(responsavel.id).update({
      'idPacientes': FieldValue.arrayRemove([paciente.id])
    });
    //firestore.collection('pacientes').doc(paciente.id).delete();
  }

  Future<List<Tarefa>> todasTarefasPaciente(
      String idPaciente, EnumTarefa enumTarefa) async {
    List<Tarefa> tarefas = [];
    // Busca proximas tarefas abertas
    await firestore
        .collection('pacientes')
        .doc(idPaciente)
        .collection('tarefas')
        .where('tipo', isEqualTo: enumTarefa.name)
        .where('date',
            isEqualTo: DateFormat('dd/MM/yyyy').format(DateTime.now()))
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
    /*  // Busca tarefas realizadas no dia
    await firestore
        .collection('pacientes')
        .doc(idPaciente)
        .collection('tarefas')
        .where('tipo', isEqualTo: enumTarefa.name)
        .where('date',
            isEqualTo: DateFormat('dd/MM/yyyy').format(DateTime.now()))
        .where('concluida', isEqualTo: true)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        for (var element in value.docs) {
          tarefas.add(Tarefa.fromMap(element.data()));
          tarefas.last.id = element.id;
        }
      }
    }); */
    return tarefas;
  }

  Stream<List<Medicamento>> todosMedicamentosPaciente(String idPaciente) {
    return firestore
        .collection('pacientes')
        .doc(idPaciente)
        .collection('medicamentos')
        .snapshots()
        .map((event) => event.docs.map((e) {
              var medicamento = Medicamento.fromMap(e.data());
              medicamento.id = e.id;
              return medicamento;
            }).toList());
  }

  Stream<List<Atividade>> todasAtividadesPaciente(String idPaciente) {
    return firestore
        .collection('pacientes')
        .doc(idPaciente)
        .collection('atividades')
        .snapshots()
        .map((event) =>
            event.docs.map((e) => Atividade.fromMap(e.data())).toList());
  }

  Stream<List<Consulta>> todasConsultasPaciente(String idPaciente) {
    return firestore
        .collection('pacientes')
        .doc(idPaciente)
        .collection('consultas')
        .snapshots()
        .map((event) => event.docs.map((e) {
              var consulta = Consulta.fromMap(e.data());
              consulta.id = e.id;
              return consulta;
            }).toList());
  }

  Future<List<Cuidador>> todosCuidadoresPaciente(String idPaciente) async {
    List<Cuidador> cuidadores = [];
    if (idPaciente.isEmpty) {
      return cuidadores;
    }
    firestore
        .collection('pacientes')
        .doc(idPaciente)
        .collection('cuidadores')
        .get()
        .then((value) async {
      if (value.docs.isNotEmpty) {
        for (var element in value.docs) {
          var cuidadorSnap =
              await firestore.collection('cuidadores').doc(element.id).get();

          if (cuidadorSnap.exists) {
            cuidadores.add(Cuidador.fromMap(cuidadorSnap.data()!));
            cuidadores.last.id = cuidadorSnap.id;
          }
        }
      }
    });
    return cuidadores;
  }
}
