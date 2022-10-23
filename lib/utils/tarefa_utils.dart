import 'package:cangurugestor/classes/medicamentos.dart';
import 'package:cangurugestor/classes/tarefa.dart';
import 'package:cangurugestor/global.dart';
import 'package:intl/intl.dart';

List<Tarefa> tarefasFromMedicamento(Medicamento medicamento) {
  double minutos = enumFrequenciaEmMinutos(
      medicamento.frequencia!, medicamento.frequenciaQuantidade);
  List<Tarefa> listaTarefas = [];
  DateTime hora = DateFormat('HH:mm').parse(medicamento.hora);
  DateTime data = DateFormat('dd/MM/yyyy')
      .parse(medicamento.dataInicio)
      .add(Duration(hours: hora.hour, minutes: hora.minute));
  DateTime dataFim = DateFormat('dd/MM/yyyy').parse(medicamento.dataFim);
  while (data.isBefore(dataFim.add(const Duration(days: 1)))) {
    Tarefa tarefa = Tarefa(
        nome: medicamento.nome,
        idTipo: medicamento.id,
        tipo: EnumTarefa.medicamento,
        dateTime: data,
        descricao: medicamento.descricao,
        observacao: medicamento.observacao,
        concluida: false);
    listaTarefas.add(tarefa);
    data = data.add(Duration(minutes: minutos.toInt()));
  }
  return listaTarefas;
}
