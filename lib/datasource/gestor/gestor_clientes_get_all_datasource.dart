import 'package:cangurugestor/global.dart';
import 'package:cangurugestor/model/gestor.dart';
import 'package:cangurugestor/model/responsavel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GestorClientesGetAllDatasource {
  Future<List<Responsavel>> todosClientesGestor(Gestor gestor) async {
    List<Responsavel> responsaveis = [];
    await getIt<FirebaseFirestore>()
        .collection('responsaveis')
        .where('idGestor', isEqualTo: gestor.id)
        .get()
        .then((value) {
      for (var element in value.docs) {
        Responsavel responsavel = Responsavel.fromMap(element.data());
        responsavel.id = element.id;
        responsaveis.add(responsavel);
      }
    });
    return responsaveis;
  }
}
