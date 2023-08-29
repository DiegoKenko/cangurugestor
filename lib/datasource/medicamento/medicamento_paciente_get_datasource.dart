import 'package:cangurugestor/global.dart';
import 'package:cangurugestor/model/medicamento.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MedicamentoPacienteGetDatasource{
    Future<Medicamento> medicamentoPaciente(
    String idMedicamento,
    String idPaciente,
  ) async {
    var doc = await getIt<FirebaseFirestore>()
        .collection('pacientes')
        .doc(idPaciente)
        .collection('medicamentos')
        .doc(idMedicamento)
        .get();

    Medicamento med = Medicamento.fromMap(doc.data()!);
    med.id = doc.id;
    return med;
  }
}