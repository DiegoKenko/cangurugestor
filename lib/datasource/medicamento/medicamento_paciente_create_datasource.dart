import 'package:cangurugestor/global.dart';
import 'package:cangurugestor/model/medicamento.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MedicamentoPacienteCreateDatasource {
  Future<Medicamento> novoMedicamentoPaciente(
    Medicamento medicamento,
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
