import 'package:cangurugestor/global.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

class MedicamentoExcluirTarefasMedicamentoDatasource {
  Future<void> excluirTodasTarefasMedicamento(
    String med,
    String idPaciente,
  ) async {
    await getIt<FirebaseFirestore>()
        .collection('pacientes')
        .doc(idPaciente)
        .collection('tarefas')
        .where('medicamento', isEqualTo: med)
        .where('tipo', isEqualTo: 'medicamento')
        .where(
          'data',
          isGreaterThanOrEqualTo: DateFormat('yyyy-MM-dd').format(
            DateTime.now(),
          ),
        )
        .get()
        .then((value) {
      for (var doc in value.docs) {
        doc.reference.delete();
      }
    });
  }
}
