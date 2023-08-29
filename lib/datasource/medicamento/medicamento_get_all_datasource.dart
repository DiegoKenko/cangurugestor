import 'package:cangurugestor/global.dart';
import 'package:cangurugestor/model/medicamento.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class MedicamentoGetAllDatasource {
  Future<List<String>> call() async {
    List<String> medReturn = [];
    getIt<FirebaseFirestore>().collection('medicamentos').get().then(
      (QuerySnapshot<Map<String, dynamic>> value) {
        for (var element in value.docs) {
          if (element.data()['nome'] != null) {
            medReturn.add(element.data()['nome']);
          }
        }
        medReturn.sort((a, b) => a.compareTo(b));
        return medReturn;
      },
    );
    return medReturn;
  }
}
