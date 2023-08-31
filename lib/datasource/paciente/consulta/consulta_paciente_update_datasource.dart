import 'package:cangurugestor/const/global.dart';
import 'package:cangurugestor/domain/entity/consulta.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ConsultaPacienteUpdateDatasource {
  Future<void> call(
    ConsultaEntity consulta,
    String idPaciente,
  ) async {
    await getIt<FirebaseFirestore>()
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
}
