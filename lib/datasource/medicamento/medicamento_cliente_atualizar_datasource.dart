import 'package:cangurugestor/global.dart';
import 'package:cangurugestor/model/medicamento.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

class MedicamentoExcluirTarefasMedicamentoDatasource {
   Future<void> atualizarMedicamentoPaciente(
    Medicamento medicamento,
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
