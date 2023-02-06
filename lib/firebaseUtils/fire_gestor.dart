import 'package:cangurugestor/model/cuidador.dart';
import 'package:cangurugestor/model/gestor.dart';
import 'package:cangurugestor/model/responsavel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreGestor {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<List<Responsavel>> todosClientesGestor(Gestor gestor) async {
    List<Responsavel> resps = [];
    if (gestor.id.isEmpty) {
      return resps;
    }
    await firestore.collection('gestores').doc(gestor.id).get().then((doc) {
      if (doc.data() != null) {
        gestor = Gestor.fromMap(doc.data()!);
        gestor.id = doc.id;
      }
    });

    for (var element in gestor.idClientes) {
      var doc = await firestore.collection('responsaveis').doc(element).get();
      if (doc.data() != null) {
        Responsavel responsavel = Responsavel.fromMap(doc.data()!);
        responsavel.id = doc.id;
        resps.add(responsavel);
      }
    }
    return resps;
  }

  Future<List<Cuidador>> todosCuidadoresGestor(Gestor gestor) async {
    List<Cuidador> cuidadores = [];
    if (gestor.id.isEmpty) {
      return cuidadores;
    }
    await firestore.collection('gestores').doc(gestor.id).get().then((doc) {
      if (doc.data() != null) {
        gestor = Gestor.fromMap(doc.data()!);
        gestor.id = doc.id;
      }
    });

    for (var element in gestor.idCuidadores) {
      if (element.isNotEmpty) {
        var doc = await firestore.collection('cuidadores').doc(element).get();
        if (doc.data() != null) {
          Cuidador cuidador = Cuidador.fromMap(doc.data()!);
          cuidador.id = doc.id;
          cuidadores.add(cuidador);
        }
      }
    }
    return cuidadores;
  }

  Future<List<Cuidador>> todosCuidadoresPaciente(
      Gestor gestor, String idPaciente,) async {
    List<Cuidador> cuidadores = [];
    if (gestor.id.isEmpty) {
      return cuidadores;
    }
    for (var i = 0; i < gestor.idCuidadores.length; i++) {
      if (gestor.idCuidadores[i].isEmpty) {
        continue;
      }
      DocumentSnapshot<Map<String, dynamic>> doc = await firestore
          .collection('cuidadores')
          .doc(gestor.idCuidadores[i])
          .get();
      Cuidador cuidador = Cuidador.fromMap(doc.data()!);
      if (cuidador.idPacientes.contains(idPaciente)) {
        cuidador.id = doc.id;
        cuidadores.add(cuidador);
      }
    }
    return cuidadores;
  }

  Future<Gestor> create(Gestor gestor) async {
    var doc = await firestore.collection('gestores').add(gestor.toMap());
    gestor.id = doc.id;
    return gestor;
  }

  Future<Gestor> read(String id) async {
    var doc = await firestore.collection('gestores').doc(id).get();
    if (doc.data() != null) {
      Gestor gestor = Gestor.fromMap(doc.data()!);
      gestor.id = doc.id;
      return gestor;
    } else {
      return Gestor();
    }
  }

  Future<Gestor> update(Gestor gestor) async {
    await firestore
        .collection('gestores')
        .doc(gestor.id)
        .update(gestor.toMap());
    return gestor;
  }
}
