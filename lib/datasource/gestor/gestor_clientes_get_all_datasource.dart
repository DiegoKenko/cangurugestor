import 'package:cangurugestor/const/global.dart';
import 'package:cangurugestor/domain/entity/gestor.dart';
import 'package:cangurugestor/domain/entity/responsavel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GestorClientesGetAllDatasource {
  Future<List<ResponsavelEntity>> call(GestorEntity gestor) async {
    List<ResponsavelEntity> responsaveis = [];
    await getIt<FirebaseFirestore>()
        .collection('responsaveis')
        .where('idGestor', isEqualTo: gestor.id)
        .get()
        .then((value) {
      for (var element in value.docs) {
        ResponsavelEntity responsavel =
            ResponsavelEntity.fromMap(element.data());
        responsavel.id = element.id;
        responsaveis.add(responsavel);
      }
    });
    return responsaveis;
  }
}
