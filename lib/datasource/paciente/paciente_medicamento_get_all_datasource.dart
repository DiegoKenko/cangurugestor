import 'package:cangurugestor/global.dart';
import 'package:cangurugestor/model/medicamento.dart';
import 'package:cangurugestor/model/paciente.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PacienteMedicamentoGetAllDatasource {
  Future<List<Medicamento>> todosMedicamentosPaciente(Paciente paciente) async {
    var doc = await getIt<FirebaseFirestore>()
        .collection('pacientes')
        .doc(paciente.id)
        .collection('medicamentos')
        .get();
    if (doc.docs.isNotEmpty) {
      return doc.docs.map((e) {
        Medicamento medicamento = Medicamento.fromMap(e.data());
        medicamento.id = e.id;
        return medicamento;
      }).toList();
    } else {
      return [];
    }
  }
}
