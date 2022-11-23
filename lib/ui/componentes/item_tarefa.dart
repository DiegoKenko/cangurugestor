import 'package:cangurugestor/classes/tarefa.dart';
import 'package:cangurugestor/ui/componentes/separador1.dart';
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
                    Text(
                      widget.tarefa.date,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(
                          Icons.schedule,
                          size: 17,
                          color: widget.tarefa.dateTime.isBefore(DateTime.now())
                              ? Theme.of(context).errorColor
                              : Theme.of(context).focusColor,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            widget.tarefa.time,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      widget.tarefa.concluida ? 'Concluída' : 'Pendente',
                      style: TextStyle(
                        color: widget.tarefa.concluida
                            ? Theme.of(context).focusColor
                            : Theme.of(context).errorColor,
                      ),
                    ),
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
                        widget.tarefa.tipo.name,
                        style: const TextStyle(
                          fontSize: 12,
                          color: corPad1,
                          letterSpacing: 2,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: Text(
                          widget.tarefa.nome.toUpperCase(),
                          style: const TextStyle(
                            letterSpacing: 2,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      widget.tarefa.descricao.isNotEmpty
                          ? Column(
                              children: [
                                const Separador1(),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 15),
                                  child: Text(
                                    widget.tarefa.descricao,
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Container(),
                      widget.tarefa.observacao.isNotEmpty
                          ? Column(
                              children: [
                                const Separador1(),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Text(
                                    widget.tarefa.observacao,
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Container(),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Transform.scale(
                  scale: 1.5,
                  child: Checkbox(
                    checkColor: corPad1,
                    hoverColor: corPad3,
                    fillColor: MaterialStateProperty.all(
                        widget.tarefa.concluida ? corPad3 : Colors.grey),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    onChanged: (value) {
                      setState(() {
                        widget.tarefa.concluida = value!;
                      });
                    },
                    value: widget.tarefa.concluida,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
