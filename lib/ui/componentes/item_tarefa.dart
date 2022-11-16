import 'package:cangurugestor/classes/tarefa.dart';
import 'package:cangurugestor/ui/componentes/styles.dart';
import 'package:flutter/material.dart';

class ItemTarefa extends StatefulWidget {
  Tarefa tarefa;
  void Function()? onTap;
  ItemTarefa({Key? key, required this.tarefa, this.onTap}) : super(key: key);

  @override
  State<ItemTarefa> createState() => _ItemTarefaState();
}

class _ItemTarefaState extends State<ItemTarefa> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Card(
        borderOnForeground: true,
        shadowColor: corPad1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 10,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: Row(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: Column(
                  children: [
                    const Icon(Icons.schedule),
                    Text(widget.tarefa.time),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.tarefa.nome,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        height: 2,
                        color: corPad1,
                      ),
                      Text(
                        widget.tarefa.observacao,
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Checkbox(
                  onChanged: (value) {
                    setState(() {
                      widget.tarefa.concluida = value!;
                    });
                  },
                  value: widget.tarefa.concluida,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
