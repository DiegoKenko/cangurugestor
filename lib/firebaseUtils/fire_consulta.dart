import 'package:cangurugestor/model/consulta.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreConsulta {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> atualizarConsultaPaciente(
      Consulta consulta, String idPaciente,) async {
    await firestore
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
      String idConsulta, String idPaciente,) async {
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
      Consulta consulta, String idPaciente,) async {
    if (idPaciente.isEmpty) {
      return consulta;
    }
    var con = await firestore
        .collection('pacientes')
        .doc(idPaciente)
        .collection('consultas')
        .add(consulta.toMap());
    consulta.id = con.id;
    return consulta;
  }

  Future<List<Consulta>> todasConsultasPaciente(String idpaciente) async {
    List<Consulta> consultas = [];
    if (idpaciente.isEmpty) {
      return consultas;
    }
    var snap = await firestore
        .collection('pacientes')
        .doc(idpaciente)
        .collection('consultas')
        .get();

    for (var doc in snap.docs) {
      var consulta = Consulta.fromMap(doc.data());
      consulta.id = doc.id;
      consultas.add(consulta);
    }
    return consultas;
  }

  void excluirConsultaPaciente(String idConsulta, String idPaciente) {
    firestore
        .collection('pacientes')
        .doc(idPaciente)
        .collection('consultas')
        .doc(idConsulta)
        .delete();
  }
}
