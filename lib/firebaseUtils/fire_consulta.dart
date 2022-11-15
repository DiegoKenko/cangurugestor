import 'package:cangurugestor/classes/consulta.dart';
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

  excluirConsultaPaciente(
      String idConsulta, String idReponsavel, String idPaciente) {
    firestore
        .collection('pacientes')
        .doc(idPaciente)
        .collection('consultas')
        .doc(idConsulta)
        .delete();
  }
}
