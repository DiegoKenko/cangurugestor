import 'package:cangurugestor/const/global.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

class MedicamentoDeleteDatasource {
  Future<void> call(
    String idMedicamento,
    String idPaciente,
  ) async {
    await getIt<FirebaseFirestore>()
        .collection('pacientes')
        .doc(idPaciente)
        .collection('medicamentos')
        .doc(idMedicamento)
        .delete();
  }
}
