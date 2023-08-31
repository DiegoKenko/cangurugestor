import 'package:cangurugestor/const/global.dart';
import 'package:cangurugestor/domain/entity/cuidador_entity.dart';
import 'package:cangurugestor/domain/entity/paciente_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PacienteCuidadorGetAllDatasource {
  Future<List<CuidadorEntity>> call(PacienteEntity paciente) async {
    List<CuidadorEntity> cuidadores = [];
    if (paciente.id.isEmpty || paciente.idCuidadores.isEmpty) {
      return cuidadores;
    } else {
      var doc = await getIt<FirebaseFirestore>()
          .collection('pacientes')
          .doc(paciente.id)
          .get();
      PacienteEntity p = PacienteEntity.fromMap(doc.data()!);
      for (var element in p.idCuidadores) {
        var docCuidador = await getIt<FirebaseFirestore>()
            .collection('cuidadores')
            .doc(element)
            .get();
        CuidadorEntity cuidador = CuidadorEntity.fromMap(docCuidador.data()!);
        cuidador.id = docCuidador.id;
        cuidadores.add(cuidador);
      }
      return cuidadores;
    }
  }
}
