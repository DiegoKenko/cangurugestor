import 'package:cangurugestor/classes/pessoa.dart';
import 'package:cangurugestor/classes/responsavel.dart';

class Gestor extends Pessoa {
  String? id;
  List<Responsavel> clientes = [];

  Gestor();

  Gestor.fromMap(Map<String, dynamic> map) : super.fromMap(map) {
    id = map['id'];
  }
}
