import 'package:cangurugestor/global.dart';
import 'package:cangurugestor/model/cuidador.dart';
import 'package:cangurugestor/model/paciente.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PacienteCuidadorGetAllDatasource {
  Future<List<Cuidador>> todosCuidadoresPaciente(Paciente paciente) async {
    List<Cuidador> cuidadores = [];
    if (paciente.id.isEmpty || paciente.idCuidadores.isEmpty) {
      return cuidadores;
    } else {
      var doc = await getIt<FirebaseFirestore>()
          .collection('pacientes')
          .doc(paciente.id)
          .get();
      Paciente p = Paciente.fromMap(doc.data()!);
      for (var element in p.idCuidadores) {
        var docCuidador = await getIt<FirebaseFirestore>()
            .collection('cuidadores')
            .doc(element)
            .get();
        Cuidador cuidador = Cuidador.fromMap(docCuidador.data()!);
        cuidador.id = docCuidador.id;
        cuidadores.add(cuidador);
      }
      return cuidadores;
    }
  }
}
