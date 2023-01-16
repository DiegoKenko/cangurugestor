import 'package:cangurugestor/model/paciente.dart';
import 'package:flutter/material.dart';

class ScrollableLista {
  mostraListaPacientes(BuildContext context, List<Paciente> pacientes) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Center(
          child: ListView.builder(
            itemCount: pacientes.length,
            itemBuilder: (context, int i) {
              if (pacientes.isNotEmpty) {
                return ListTile(
                  leading: const Icon(Icons.add),
                  title: Text(pacientes[i].nome),
                );
              } else {
                return Container();
              }
            },
          ),
        );
      },
    );
  }
}
