import 'package:cangurugestor/global.dart';
import 'package:cangurugestor/model/atividade.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AtividadePacienteGetDatasource {
  Future<Atividade> call(String idAtividade, String idPaciente) async {
    DocumentSnapshot<Map<String, dynamic>> snap =
        await getIt<FirebaseFirestore>()
            .collection('pacientes')
            .doc(idPaciente)
            .collection('atividades')
            .doc(idAtividade)
            .get();
    Atividade atividade = Atividade.fromMap(snap.data()!);
    atividade.id = snap.id;
    return atividade;
  }
}
