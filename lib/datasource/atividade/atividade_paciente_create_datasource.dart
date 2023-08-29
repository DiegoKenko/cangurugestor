import 'package:cangurugestor/global.dart';
import 'package:cangurugestor/model/atividade.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AtividadePacienteCreateDatasource {
  Future<Atividade> novaAtividadePaciente(
    Atividade atividade,
    String idPaciente,
  ) async {
    var ativ = await getIt<FirebaseFirestore>()
        .collection('pacientes')
        .doc(idPaciente)
        .collection('atividades')
        .add(atividade.toMap());

    atividade.id = ativ.id;
    return atividade;
  }
}
