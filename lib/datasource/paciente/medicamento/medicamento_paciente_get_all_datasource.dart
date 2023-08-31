import 'package:cangurugestor/const/global.dart';
import 'package:cangurugestor/domain/entity/medicamento.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MedicamentoPacienteGetAllDatasource {
  Future<List<MedicamentoEntity>> todosMedicamentosPaciente(
    String idPaciente,
  ) async {
    List<MedicamentoEntity> meds = [];
    if (idPaciente.isEmpty) {
      return meds;
    }
    await getIt<FirebaseFirestore>()
        .collection('pacientes')
        .doc(idPaciente)
        .collection('medicamentos')
        .get()
        .then((value) {
      for (var doc in value.docs) {
        MedicamentoEntity med = MedicamentoEntity.fromMap(doc.data());
        med.id = doc.id;
        meds.add(med);
      }
    });
    return meds;
  }
}
