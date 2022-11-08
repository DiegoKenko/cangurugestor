import 'package:cangurugestor/classes/atividade.dart';
import 'package:cangurugestor/classes/consulta.dart';
import 'package:cangurugestor/classes/cuidador.dart';
import 'package:cangurugestor/classes/gestor.dart';
import 'package:cangurugestor/classes/login.dart';
import 'package:cangurugestor/classes/medicamentos.dart';
import 'package:cangurugestor/classes/paciente.dart';
import 'package:cangurugestor/classes/responsavel.dart';
import 'package:cangurugestor/classes/tarefa.dart';
import 'package:cangurugestor/global.dart';
import 'package:cangurugestor/utils/create_animated_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cangurugestor/ui/telas/gest/gest_painel.dart';
import 'package:cangurugestor/global.dart' as global;
import 'package:intl/intl.dart';

class MeuFirestore {
  static Future<Responsavel> incluirResponsavel(Responsavel responsavel) async {
    var doc = await FirebaseFirestore.instance
        .collection('responsaveis')
        .add(responsavel.toMap());
    responsavel.id = doc.id;
    atualizaLogin(Login(
        colecao: 'responsaveis',
        cpf: responsavel.cpf,
        doc: doc.id,
        funcao: 'responsaveis',
        senha: responsavel.senha,
        ativo: responsavel.ativo));
    return responsavel;
  }

  static atualizarResponavel(Responsavel responsavel) {
    FirebaseFirestore.instance
        .collection('responsaveis')
        .doc(responsavel.id)
        .get()
        .then(
      (snapshot) {
        snapshot.reference.update(responsavel.toMap());
        // Update or create its login too
        atualizaLogin(Login(
            colecao: 'responsaveis',
            cpf: responsavel.cpf,
            doc: snapshot.reference.id,
            funcao: 'responsavel',
            senha: responsavel.senha,
            ativo: responsavel.ativo));
      },
    );
  }

  static excluirResponsavel(String idReponsavel) {
    FirebaseFirestore.instance
        .collection('responsaveis')
        .doc(idReponsavel)
        .delete();

    deleteLogin(idReponsavel);
  }

  static Future<Paciente> incluirPaciente(Paciente paciente) async {
    FirebaseFirestore.instance
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

  static atualizarPaciente(Paciente paciente) {
    FirebaseFirestore.instance
        .collection('pacientes')
        .doc(paciente.id)
        .get()
        .then(
      (snapshot) {
        if (snapshot.exists) {
          snapshot.reference.update(paciente.toMap());
          // Adiciona paciente ao responsavel
          adicionarPacienteResponsavel(paciente);
        }
      },
    );
  }

  static excluirPaciente(Paciente paciente) {
    FirebaseFirestore.instance
        .collection('pacientes')
        .doc(paciente.id)
        .delete();
    excluirPacienteResponsavel(paciente);
  }

  static Future<Cuidador> incluirCuidador(Cuidador cuidador) async {
    var cuid = await FirebaseFirestore.instance
        .collection('cuidadores')
        .add(cuidador.toMap());
    cuidador.id = cuid.id;

    atualizaLogin(Login(
        colecao: 'cuidadores',
        cpf: cuidador.cpf,
        doc: cuid.id,
        funcao: 'cuidador',
        senha: cuidador.senha,
        ativo: cuidador.ativo));
    return cuidador;
  }

  static atualizarCuidador(Cuidador cuidador) {
    FirebaseFirestore.instance
        .collection('cuidadores')
        .doc(cuidador.id)
        .get()
        .then(
      (snapshot) {
        if (snapshot.exists) {
          snapshot.reference.update(cuidador.toMap());
          atualizaLogin(Login(
              colecao: 'cuidadores',
              cpf: cuidador.cpf,
              doc: snapshot.reference.id,
              funcao: 'cuidador',
              senha: cuidador.senha,
              ativo: cuidador.ativo));
        }
      },
    );
  }

  static excluirCuidador(String idCuidador) {
    FirebaseFirestore.instance
        .collection('cuidadores')
        .doc(idCuidador)
        .delete();
    deleteLogin(idCuidador);
  }

  static atualizarConsultaPaciente(Consulta consulta, String idPaciente) {
    FirebaseFirestore.instance
        .collection('pacientes')
        .doc(idPaciente)
        .collection('consultas')
        .doc(consulta.id)
        .get()
        .then(
      (snapshot) {
        if (snapshot.exists) {
          snapshot.reference.update(consulta.toMap());
        }
      },
    );
  }

  static novaConsultaPaciente(
      Consulta consulta, String idReponsavel, String idPaciente) {
    FirebaseFirestore.instance
        .collection('pacientes')
        .doc(idPaciente)
        .collection('consultas')
        .add(consulta.toMap())
        .then((DocumentReference<Map<String, dynamic>> value) {});
  }

  static excluirConsultaPaciente(
      String idConsulta, String idReponsavel, String idPaciente) {
    FirebaseFirestore.instance
        .collection('pacientes')
        .doc(idPaciente)
        .collection('consultas')
        .doc(idConsulta)
        .delete();
  }

  static atualizarAtividadePaciente(Atividade atividade, String idPaciente) {
    FirebaseFirestore.instance
        .collection('pacientes')
        .doc(idPaciente)
        .collection('atividades')
        .doc(atividade.id)
        .get()
        .then((value) => value.reference.update(atividade.toMap()));
  }

  static novaAtividadePaciente(
      Atividade atividade, String idReponsavel, String idPaciente) {
    FirebaseFirestore.instance
        .collection('pacientes')
        .doc(idPaciente)
        .collection('atividades')
        .add(atividade.toMap())
        .then((DocumentReference<Map<String, dynamic>> value) {
      atividade.id = value.id;
    });
  }

  static excluirAtividadePaciente(String idAtividade, String idPaciente) {
    FirebaseFirestore.instance
        .collection('pacientes')
        .doc(idPaciente)
        .collection('atividades')
        .doc(idAtividade)
        .delete();
  }

  static atualizarMedicamentoPaciente(
      Medicamento medicamento, String idPaciente) {
    FirebaseFirestore.instance
        .collection('pacientes')
        .doc(idPaciente)
        .collection('medicamentos')
        .doc(medicamento.id)
        .get()
        .then(
      (snapshot) {
        if (snapshot.exists) {
          snapshot.reference.update(medicamento.toMap());
        }
      },
    );
  }

  static Future<Medicamento> novoMedicamentoPaciente(
      Medicamento medicamento, String idPaciente) async {
    var med = await FirebaseFirestore.instance
        .collection('pacientes')
        .doc(idPaciente)
        .collection('medicamentos')
        .add(medicamento.toMap());

    medicamento.id = med.id;

    return medicamento;
  }

  static void excluirMedicamento(String idMedicamento, String idPaciente) {
    FirebaseFirestore.instance
        .collection('pacientes')
        .doc(idPaciente)
        .collection('medicamentos')
        .doc(idMedicamento)
        .delete();
  }

  static Future<List<String>> todosMedicamentos() async {
    List<String> medReturn = [];
    FirebaseFirestore.instance.collection('medicamentos').get().then(
      (QuerySnapshot<Map<String, dynamic>> value) {
        for (var element in value.docs) {
          if (element.data()['nome'] != null) {
            medReturn.add(element.data()['nome']);
          }
        }
        medReturn.sort((a, b) => a.compareTo(b));
        return medReturn;
      },
    );
    return medReturn;
  }

  static Future<List<String>> todasAtividades() async {
    List<String> atvReturn = [];
    FirebaseFirestore.instance.collection('atividades').get().then(
      (QuerySnapshot<Map<String, dynamic>> value) {
        for (var element in value.docs) {
          if (element.data()['nome'] != null) {
            atvReturn.add(element.data()['nome']);
          }
        }
        atvReturn.sort((a, b) => a.compareTo(b));
        return atvReturn;
      },
    );
    return atvReturn;
  }

  static Future<List<Medicamento>> todosMedicamentosPaciente(
      String idPaciente) async {
    List<Medicamento> medReturn = [];
    if (idPaciente.isEmpty) {
      return medReturn;
    }
    var med = await FirebaseFirestore.instance
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

  static Future<List<Atividade>> todasAtividadesPaciente(
      String idPaciente) async {
    List<Atividade> atvReturn = [];
    if (idPaciente.isEmpty) {
      return atvReturn;
    }
    var atv = await FirebaseFirestore.instance
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

  static Future<List<Consulta>> todasConsultasPaciente(
      String idPaciente) async {
    List<Consulta> consultaReturn = [];
    if (idPaciente.isEmpty) {
      return consultaReturn;
    }
    var cons = await FirebaseFirestore.instance
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

  autenticarUsuarioGoogle(BuildContext context, User user) async {
    Gestor gestor = Gestor();
    await FirebaseFirestore.instance
        .collection('login')
        .where('googleEmail', isEqualTo: user.email)
        .get()
        .then(
          (snap) => {
            if (snap.docs.isNotEmpty)
              {
                if (snap.docs.first.data()['funcao'] == 'gestor')
                  {
                    // Grava gestor atual
                    global.idGestorGlobal = snap.docs.first.id,
                    FirebaseFirestore.instance
                        .collection('gestores')
                        .doc(snap.docs.first.data()['doc'])
                        .get()
                        .then((value) {
                      gestor = Gestor.fromMap(value.data()!);
                    }),
                    // Busca todos os clientes
                    FirebaseFirestore.instance
                        .collection('responsaveis')
                        .where('gestor', isEqualTo: global.idGestorGlobal)
                        .get()
                        .then((value) {
                      List<Responsavel> responsaveis = [];
                      for (var doc in value.docs) {
                        responsaveis.add(Responsavel.fromMap(doc.data()));
                        responsaveis.last.setId(doc.id);
                      }
                      responsaveis.sort((a, b) =>
                          a.nome.toUpperCase().compareTo(b.nome.toUpperCase()));
                      gestor.todosClientes(responsaveis);
                      // Painel gestor
                      Navigator.pushReplacement(context,
                          MyRoute().createRoute(PainelGestor(gestor: gestor)));
                    }),
                  }
                else
                  {}
              }
          },
          onError: (error, stackTrace) {},
        );
  }

  static atualizaLogin(Login login) {
    FirebaseFirestore.instance
        .collection('login')
        .where('doc', isEqualTo: login.doc)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        value.docs.first.reference.set(login.toMap());
      } else {
        FirebaseFirestore.instance.collection('login').add(login.toMap());
      }
    });
  }

  static deleteLogin(String doc) {
    FirebaseFirestore.instance
        .collection('login')
        .where('doc', isEqualTo: doc)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        value.docs.first.reference.delete();
      }
    });
  }

  Future<List<Paciente>> todosPacientes(String idResponsavel) async {
    List<Paciente> pacientes = [];
    if (idResponsavel.isNotEmpty) {
      await FirebaseFirestore.instance
          .collection('pacientes')
          .where('responsavel', isEqualTo: idResponsavel)
          .get()
          .then((value) {
        for (var doc in value.docs) {
          pacientes.add(Paciente.fromMap(doc.data()));
          pacientes.last.id = doc.id;
        }
      });
    }
    return pacientes;
  }

  Future<List<Paciente>> todosPacientesCuidador(
      String responsavelId, String cuidadorId) async {
    List<Paciente> pacientes = [];
    if (cuidadorId.isNotEmpty || responsavelId.isNotEmpty) {
      var paciValue = await FirebaseFirestore.instance
          .collection('pacientes')
          .where('responsavel', isEqualTo: responsavelId)
          .get();

      for (var doc in paciValue.docs) {
        var cuidValue =
            await doc.reference.collection('cuidadores').doc(cuidadorId).get();

        if (cuidValue.exists) {
          pacientes.add(Paciente.fromMap(doc.data()));
          pacientes.last.id = doc.id;
        }
      }
    }
    return pacientes;
  }

  Future<List<Cuidador>> todosCuidadores(String idResponsavel) async {
    List<Cuidador> cuidadores = [];
    if (idResponsavel.isNotEmpty) {
      await FirebaseFirestore.instance
          .collection('cuidadores')
          .where('responsavel', isEqualTo: idResponsavel)
          .get()
          .then((value) {
        for (var doc in value.docs) {
          cuidadores.add(Cuidador.fromMap(doc.data()));
          cuidadores.last.id = doc.id;
        }
      });
    }
    return cuidadores;
  }

  Future<Paciente> buscarPaciente(String idPaciente) async {
    Paciente paciente = Paciente();
    if (idPaciente.isNotEmpty) {
      await FirebaseFirestore.instance
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

  static incluirPacienteCuidador(String idPaciente, String idCuidador) {
    if (idPaciente.isNotEmpty && idCuidador.isNotEmpty) {
      FirebaseFirestore.instance
          .collection('pacientes')
          .doc(idPaciente)
          .collection('cuidadores')
          .doc(idCuidador)
          .set({'data': DateTime.now()});
      FirebaseFirestore.instance
          .collection('cuidadores')
          .doc(idCuidador)
          .collection('pacientes')
          .doc(idPaciente)
          .set({'data': DateTime.now()});
    }
  }

  static excluirPacienteCuidador(String idPaciete, String idCuidador) {
    if (idPaciete.isNotEmpty && idCuidador.isNotEmpty) {
      FirebaseFirestore.instance
          .collection('pacientes')
          .doc(idPaciete)
          .collection('cuidadores')
          .doc(idCuidador)
          .delete();

      FirebaseFirestore.instance
          .collection('cuidadores')
          .doc(idCuidador)
          .collection('pacientes')
          .doc(idPaciete)
          .delete();
    }
  }

  /*
  Grava todas tarefas de acordo com data inicial e final do medicamento
  */
  static criaTarefasMedicamento(
      Medicamento med, String idPaciente, List<Tarefa> tarefas) {
    for (var tarefa in tarefas) {
      FirebaseFirestore.instance
          .collection('pacientes')
          .doc(idPaciente)
          .collection('tarefas')
          .add(tarefa.toMap());
    }
  }

  static excluirTarefasMedicamento(
      Medicamento med, String idPaciente, String idTarefa) async {
    FirebaseFirestore.instance
        .collection('pacientes')
        .doc(idPaciente)
        .collection('tarefas')
        .doc(idTarefa)
        .delete();
  }

  static excluirTodasTarefasMedicamento(String med, String idPaciente) {
    FirebaseFirestore.instance
        .collection('pacientes')
        .doc(idPaciente)
        .collection('tarefas')
        .where('medicamento', isEqualTo: med)
        .where('tipo', isEqualTo: 'medicamento')
        .where('data',
            isGreaterThanOrEqualTo:
                DateFormat('yyyy-MM-dd').format(DateTime.now()))
        .get()
        .then((value) {
      for (var doc in value.docs) {
        doc.reference.delete();
      }
    });
  }

  static Future<List<Tarefa>> todasTarefasPaciente(
      String idPaciente, EnumTarefa enumTarefa) async {
    List<Tarefa> tarefas = [];
    // Busca proximas tarefas abertas
    await FirebaseFirestore.instance
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
    await FirebaseFirestore.instance
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

  static void adicionarPacienteResponsavel(Paciente paciente) {
    // Adiciona paciente ao responsavel
    FirebaseFirestore.instance
        .collection('responsaveis')
        .doc(paciente.idResponsavel)
        .get()
        .then(
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

  static void excluirPacienteResponsavel(Paciente paciente) {
    FirebaseFirestore.instance
        .collection('responsaveis')
        .doc(paciente.idResponsavel)
        .get()
        .then(
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

  static Future<List<Tarefa>> tarefasMedicamento(
      String idMedicamento, String idPaciente,
      {bool concluida = false}) async {
    List<Tarefa> tarefas = [];
    if (idMedicamento.isEmpty || idPaciente.isEmpty) return tarefas;
    var value = await FirebaseFirestore.instance
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
}
