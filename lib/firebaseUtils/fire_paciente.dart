import 'package:cangurugestor/classes/atividade.dart';
import 'package:cangurugestor/classes/consulta.dart';
import 'package:cangurugestor/classes/medicamento.dart';
import 'package:cangurugestor/classes/paciente.dart';
import 'package:cangurugestor/classes/responsavel.dart';
import 'package:cangurugestor/classes/tarefa.dart';
import 'package:cangurugestor/global.dart';
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

  Future<Paciente> incluirPaciente(Paciente paciente) async {
    firestore
        .collection('pacientes')
        .add(paciente.toMap())
        .then((DocumentReference<Map<String, dynamic>> value) {
      if (paciente.prescricao != null) {
        if (paciente.prescricao!.medicamentos != null) {
          if (paciente.prescricao!.medicamentos!.isNotEmpty) {
            for (var element in paciente.prescricao!.medicamentos!) {
              value.collection('medicamentos').add(element.toMap());
            }
          }
        }
        if (paciente.prescricao!.atividades != null) {
          if (paciente.prescricao!.atividades!.isNotEmpty) {
            for (var element in paciente.prescricao!.atividades!) {
              value.collection('atividades').add(element.toMap());
            }
          }
        }
      }
      if (paciente.consultas != null) {
        if (paciente.consultas!.isNotEmpty) {
          for (var element in paciente.consultas!) {
            value.collection('consultas').add(element.toMap());
          }
        }
      }
      paciente.id = value.id;
      // Adiciona paciente ao responsavel
      adicionarPacienteResponsavel(paciente);
      return paciente;
    });
    return paciente;
  }

  atualizarPaciente(Paciente paciente) {
    firestore.collection('pacientes').doc(paciente.id).get().then(
      (snapshot) {
        if (snapshot.exists) {
          snapshot.reference.update(paciente.toMap());
          // Adiciona paciente ao responsavel
          adicionarPacienteResponsavel(paciente);
        }
      },
    );
  }

  excluirPaciente(Paciente paciente) {
    firestore.collection('pacientes').doc(paciente.id).delete();
    excluirPacienteResponsavel(paciente);
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

  void adicionarPacienteResponsavel(Paciente paciente) {
    // Adiciona paciente ao responsavel
    firestore.collection('responsaveis').doc(paciente.idResponsavel).get().then(
      (snapshotResp) {
        if (snapshotResp.exists) {
          var responsavel = Responsavel.fromMap(snapshotResp.data()!);
          responsavel.idPacientes ??= [];
          if (!responsavel.idPacientes!.contains(paciente.id)) {
            responsavel.idPacientes!.add(paciente.id);
            snapshotResp.reference.update(responsavel.toMap());
          }
        }
      },
    );
  }

  void excluirPacienteResponsavel(Paciente paciente) {
    firestore.collection('responsaveis').doc(paciente.idResponsavel).get().then(
      (snapshotResp) {
        if (snapshotResp.exists) {
          var responsavel = Responsavel.fromMap(snapshotResp.data()!);
          responsavel.idPacientes ??= [];
          if (!responsavel.idPacientes!.contains(paciente.id)) {
            responsavel.idPacientes!.remove(paciente.id);
            snapshotResp.reference.update(responsavel.toMap());
          }
        }
      },
    );
  }

  Future<List<Medicamento>> todosMedicamentosPaciente(String idPaciente) async {
    List<Medicamento> medReturn = [];
    if (idPaciente.isEmpty) {
      return medReturn;
    }
    var med = await firestore
        .collection('pacientes')
        .doc(idPaciente)
        .collection('medicamentos')
        .get();

    for (var element in med.docs) {
      medReturn.add(Medicamento.fromMap(element.data()));
      medReturn.last.id = element.id;
    }
    return medReturn;
  }

  Future<List<Atividade>> todasAtividadesPaciente(String idPaciente) async {
    List<Atividade> atvReturn = [];
    if (idPaciente.isEmpty) {
      return atvReturn;
    }
    var atv = await firestore
        .collection('pacientes')
        .doc(idPaciente)
        .collection('atividades')
        .get();

    for (var element in atv.docs) {
      atvReturn.add(Atividade.fromMap(element.data()));
      atvReturn.last.id = element.id;
    }
    return atvReturn;
  }

  Future<List<Consulta>> todasConsultasPaciente(String idPaciente) async {
    List<Consulta> consultaReturn = [];
    if (idPaciente.isEmpty) {
      return consultaReturn;
    }
    var cons = await firestore
        .collection('pacientes')
        .doc(idPaciente)
        .collection('consultas')
        .get();
    for (var element in cons.docs) {
      consultaReturn.add(Consulta.fromMap(element.data()));
      consultaReturn.last.id = element.id;
    }
    return consultaReturn;
  }
}
