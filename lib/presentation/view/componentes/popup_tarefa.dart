import 'package:cangurugestor/domain/entity/tarefa.dart';
import 'package:cangurugestor/presentation/view/componentes/form_cadastro.dart';
import 'package:cangurugestor/presentation/view/componentes/form_cadastro_data.dart';
import 'package:cangurugestor/presentation/view/componentes/form_cadastro_hora.dart';
import 'package:cangurugestor/presentation/view/componentes/styles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PopUpTarefa extends StatefulWidget {
  const PopUpTarefa({Key? key, required this.tarefa}) : super(key: key);
  final TarefaEntity tarefa;

  @override
  State<PopUpTarefa> createState() => _PopUpTarefaState();
}

class _PopUpTarefaState extends State<PopUpTarefa> {
  final TextEditingController _dataController = TextEditingController();
  final TextEditingController _horaController = TextEditingController();
  final TextEditingController _obsController = TextEditingController();

  @override
  void dispose() {
    _dataController.dispose();
    _horaController.dispose();
    _obsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _dataController.text = widget.tarefa.date;
    _horaController.text = widget.tarefa.time;
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      actions: [
        TextButton(
          onPressed: () {},
          child: const Text('Excluir'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () {
            widget.tarefa.setDateFromString(
              _dataController.text,
            );
            widget.tarefa.setTimeFromString(
              _horaController.text,
            );
            widget.tarefa.observacao = _obsController.text;

            Navigator.pop(context);
          },
          child: const Text('Salvar'),
        ),
      ],
      title: Column(
        children: [
          Text(
            'Editar Tarefa',
            style: kEditTarefaTextStyle,
          ),
          const SizedBox(height: 10),
          FormCadastroData(
            controller: _dataController,
            labelText: 'Data',
            enabled: true,
            dataInicial: DateTime.now(),
            dataUltima: DateTime.now().add(const Duration(days: 365)),
            dataPrimeira: DateTime.now(),
          ),
          FormCadastroHora(
            onTimeChanged: (time) {
              var format = DateFormat('HH:mm').format(
                DateTime(
                  0,
                  0,
                  0,
                  time.hour,
                  time.minute,
                ),
              );
              _horaController.text = format;
            },
            controller: _horaController,
            labelText: 'Hora',
            enabled: true,
          ),
          FormCadastro(
            textInputType: TextInputType.multiline,
            onChanged: (value) {},
            enabled: true,
            obrigatorio: false,
            controller: _obsController,
            labelText: 'Observação',
            multiLine: true,
          )
        ],
      ),
      backgroundColor: Colors.white,
    );
  }
}
