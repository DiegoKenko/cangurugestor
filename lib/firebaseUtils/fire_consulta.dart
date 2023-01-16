import 'package:cangurugestor/model/consulta.dart';
import 'package:cangurugestor/model/paciente.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreConsulta {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  atualizarConsultaPaciente(Consulta consulta, String idPaciente) {
    firestore
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

  Future<Consulta> consultaPaciente(
      String idConsulta, String idPaciente) async {
    var consulta = Consulta();
    var snapshot = await firestore
        .collection('pacientes')
        .doc(idPaciente)
        .collection('consultas')
        .doc(idConsulta)
        .get();
    if (snapshot.exists) {
      consulta = Consulta.fromMap(snapshot.data()!);
      consulta.id = snapshot.id;
    }
    return consulta;
  }

  Future<Consulta> novaConsultaPaciente(
      Consulta consulta, String idPaciente) async {
    var con = await firestore
        .collection('pacientes')
        .doc(idPaciente)
        .collection('consultas')
        .add(consulta.toMap());
    consulta.id = con.id;
    return consulta;
  }

  Future<List<Consulta>> todasConsultasPaciente(Paciente paciente) {
    var consultas = <Consulta>[];
    return firestore
        .collection('pacientes')
        .doc(paciente.id)
        .collection('consultas')
        .get()
        .then((snapshot) {
      for (var doc in snapshot.docs) {
        var consulta = Consulta.fromMap(doc.data());
        consulta.id = doc.id;
        consultas.add(consulta);
      }
      return consultas;
    });
  }

  void excluirConsultaPaciente(
      String idConsulta, String idReponsavel, String idPaciente) {
    firestore
        .collection('pacientes')
        .doc(idPaciente)
        .collection('consultas')
        .doc(idConsulta)
        .delete();
  }
}
