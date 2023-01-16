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

      if (paciente.consultas.isNotEmpty) {
        for (var element in paciente.consultas) {
          value.collection('consultas').add(element.toMap());
        }
      }
      paciente.id = value.id;
      // Adiciona paciente ao responsavel
      adicionarPacienteResponsavel(paciente);
      return paciente;
    });
    return paciente;
  }

  void atualizarPaciente(Paciente paciente) {
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

  void excluirPaciente(Paciente paciente) {
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
          responsavel.idPacientes;
          if (!responsavel.idPacientes.contains(paciente.id)) {
            responsavel.idPacientes.add(paciente.id);
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
          responsavel.idPacientes;
          if (!responsavel.idPacientes.contains(paciente.id)) {
            responsavel.idPacientes.remove(paciente.id);
            snapshotResp.reference.update(responsavel.toMap());
          }
        }
      },
    );
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
