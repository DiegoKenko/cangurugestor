import 'package:cangurugestor/const/global.dart';
import 'package:cangurugestor/domain/entity/medicamento_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MedicamentoPacienteAddDatasource {
  Future<MedicamentoEntity> call(
    MedicamentoEntity medicamento,
    String idPaciente,
  ) async {
    var med = await getIt<FirebaseFirestore>()
        .collection('pacientes')
        .doc(idPaciente)
        .collection('medicamentos')
        .add(medicamento.toMap());

    medicamento.id = med.id;

    return medicamento;
  }
}
