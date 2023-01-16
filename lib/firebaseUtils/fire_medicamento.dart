import 'package:cangurugestor/model/medicamento.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class FirestoreMedicamento {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  excluirTodasTarefasMedicamento(String med, String idPaciente) {
    firestore
        .collection('pacientes')
        .doc(idPaciente)
        .collection('tarefas')
        .where('medicamento', isEqualTo: med)
        .where('tipo', isEqualTo: 'medicamento')
        .where('data',
            isGreaterThanOrEqualTo:
                DateFormat('yyyy-MM-dd').format(DateTime.now()))
        .get()
        .then((value) {
      for (var doc in value.docs) {
        doc.reference.delete();
      }
    });
  }

  void atualizarMedicamentoPaciente(
      Medicamento medicamento, String idPaciente) {
    firestore
        .collection('pacientes')
        .doc(idPaciente)
        .collection('medicamentos')
        .doc(medicamento.id)
        .get()
        .then(
      (snapshot) {
        if (snapshot.exists) {
          snapshot.reference.update(medicamento.toMap());
        }
      },
    );
  }

  Future<Medicamento> novoMedicamentoPaciente(
      Medicamento medicamento, String idPaciente) async {
    var med = await firestore
        .collection('pacientes')
        .doc(idPaciente)
        .collection('medicamentos')
        .add(medicamento.toMap());

    medicamento.id = med.id;

    return medicamento;
  }

  void excluirMedicamentoPaciente(String idMedicamento, String idPaciente) {
    firestore
        .collection('pacientes')
        .doc(idPaciente)
        .collection('medicamentos')
        .doc(idMedicamento)
        .delete();
  }

  Future<Medicamento> medicamentoPaciente(
      String idMedicamento, String idPaciente) async {
    Medicamento med = Medicamento();
    await firestore
        .collection('pacientes')
        .doc(idPaciente)
        .collection('medicamentos')
        .doc(idMedicamento)
        .get()
        .then((snapshot) {
      if (snapshot.exists) {
        med = Medicamento.fromMap(snapshot.data()!);
        med.id = snapshot.id;
      }
    });
    return med;
  }

  Future<List<Medicamento>> todosMedicamentosPaciente(String idPaciente) async {
    List<Medicamento> meds = [];
    if (idPaciente.isEmpty) {
      return meds;
    }
    await firestore
        .collection('pacientes')
        .doc(idPaciente)
        .collection('medicamentos')
        .get()
        .then((value) {
      for (var doc in value.docs) {
        Medicamento med = Medicamento.fromMap(doc.data());
        med.id = doc.id;
        meds.add(med);
      }
    });
    return meds;
  }

  Future<List<String>> todosMedicamentos() async {
    List<String> medReturn = [];
    firestore.collection('medicamentos').get().then(
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
