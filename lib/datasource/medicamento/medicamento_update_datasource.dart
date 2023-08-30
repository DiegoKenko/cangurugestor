import 'package:cangurugestor/const/global.dart';
import 'package:cangurugestor/domain/entity/medicamento.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MedicamentoUpdateDatasource {
  Future<void> call(
    MedicamentoEntity medicamento,
    String idPaciente,
  ) async {
    await getIt<FirebaseFirestore>()
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
}
