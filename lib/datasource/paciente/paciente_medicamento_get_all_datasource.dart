import 'package:cangurugestor/const/global.dart';
import 'package:cangurugestor/domain/entity/medicamento_entity.dart';
import 'package:cangurugestor/domain/entity/paciente_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PacienteMedicamentoGetAllDatasource {
  Future<List<MedicamentoEntity>> call(PacienteEntity paciente) async {
    var doc = await getIt<FirebaseFirestore>()
        .collection('pacientes')
        .doc(paciente.id)
        .collection('medicamentos')
        .get();
    if (doc.docs.isNotEmpty) {
      return doc.docs.map((e) {
        MedicamentoEntity medicamento = MedicamentoEntity.fromMap(e.data());
        medicamento.id = e.id;
        return medicamento;
      }).toList();
    } else {
      return [];
    }
  }
}
