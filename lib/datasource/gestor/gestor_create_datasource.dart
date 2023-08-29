import 'package:cangurugestor/global.dart';
import 'package:cangurugestor/model/gestor.dart';
import 'package:cangurugestor/model/pessoa.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GestorCreateDatasource {
  Future<Gestor> create(Pessoa pessoa) async {
    Gestor gestor = Gestor.fromPessoa(pessoa);
    DocumentReference<Map<String, dynamic>> doc =
        await getIt<FirebaseFirestore>()
            .collection('gestores')
            .add(gestor.toMap());
    gestor.id = doc.id;

    return gestor;
  }
}
