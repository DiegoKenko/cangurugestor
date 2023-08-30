import 'package:cangurugestor/const/global.dart';
import 'package:cangurugestor/domain/entity/medicamento.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MedicamentoPacienteGetDatasource {
  Future<MedicamentoEntity> call(
    String idMedicamento,
    String idPaciente,
  ) async {
    var doc = await getIt<FirebaseFirestore>()
        .collection('pacientes')
        .doc(idPaciente)
        .collection('medicamentos')
        .doc(idMedicamento)
        .get();

    MedicamentoEntity med = MedicamentoEntity.fromMap(doc.data()!);
    med.id = doc.id;
    return med;
  }
}
