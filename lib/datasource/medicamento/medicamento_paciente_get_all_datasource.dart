import 'package:cangurugestor/global.dart';
import 'package:cangurugestor/model/medicamento.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MedicamentoPacienteGetAllDatasource{
    Future<List<Medicamento>> todosMedicamentosPaciente(String idPaciente) async {
    List<Medicamento> meds = [];
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
        Medicamento med = Medicamento.fromMap(doc.data());
        med.id = doc.id;
        meds.add(med);
      }
    });
    return meds;
  }
}