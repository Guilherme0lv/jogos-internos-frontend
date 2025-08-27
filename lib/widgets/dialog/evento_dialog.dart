import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:projeto_web/controllers/evento_controller.dart';
import 'package:projeto_web/models/evento.dart';
import 'package:projeto_web/widgets/dialog/default_dialog_container.dart';
import 'package:projeto_web/widgets/dialog/generic_edit_dialog.dart';

class EventoDialog extends StatefulWidget {
  final Evento? evento;
  EventoDialog({super.key, this.evento});

  @override
  State<EventoDialog> createState() => _EventoDialogState();
}

class _EventoDialogState extends State<EventoDialog> {
  final eventoController = GetIt.instance<EventoController>();
  final DateFormat formatador = DateFormat("dd/MM/yyyy");

  late TextEditingController tipoEventoController;
  DateTime? dataInicio;
  DateTime? dataFim;

  @override
  void initState() {
    super.initState();
    tipoEventoController = TextEditingController(
      text: widget.evento?.tipoEvento ?? "",
    );
    if (widget.evento?.dataInicio != null &&
        widget.evento!.dataInicio.isNotEmpty) {
      try {
        dataInicio = formatador.parse(widget.evento!.dataInicio);
      } catch (_) {
        dataInicio = null;
      }
    }

    if (widget.evento?.dataFim != null && widget.evento!.dataFim.isNotEmpty) {
      try {
        dataFim = formatador.parse(widget.evento!.dataFim);
      } catch (_) {
        dataFim = null;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdicao = widget.evento != null;

    return AlertDialog(
      title: Text(isEdicao ? "Informações do Evento" : "Novo Evento"),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => GenericEditDialog(
                    titulo: isEdicao ? "Editar Evento" : "Criar Evento",
                    campos: {
                      "Tipo do Evento": tipoEventoController.text,
                      "Data de Início": dataInicio != null
                          ? formatador.format(dataInicio!)
                          : "",
                      "Data de Fim": dataFim != null
                          ? formatador.format(dataFim!)
                          : "",
                    },
                    onSalvar: (valores) async {
                      final novoOuEditado = Evento(
                        tipoEvento: valores["Tipo do Evento"] ?? "",
                        dataInicio: valores["Data de Início"] ?? "",
                        dataFim: valores["Data de Fim"] ?? "",
                      );

                      if (isEdicao) {
                        await eventoController.updateEvento(
                          novoOuEditado,
                          widget.evento!.tipoEvento,
                        );
                      } else {
                        await eventoController.createEvento(novoOuEditado);
                      }
                    },
                  ),
                );
              },
              child: Text(
                isEdicao ? "Editar" : "Criar",
                style: const TextStyle(color: Colors.white),
              ),
            ),
            if (isEdicao)
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                onPressed: () async {
                  await eventoController.removeEvento(
                    widget.evento!.tipoEvento,
                  );
                  Navigator.of(context).pop();
                },
                child: const Text(
                  "Excluir",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                "Fechar",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ],
      content: isEdicao
          ? IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  DefaultDialogContainer(
                    child: Text(
                      "Tipo: ${widget.evento!.tipoEvento}",
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                  DefaultDialogContainer(
                    child: Text(
                      "Início: ${dataInicio != null ? formatador.format(dataInicio!) : ""}",
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                  DefaultDialogContainer(
                    child: Text(
                      "Fim: ${dataFim != null ? formatador.format(dataFim!) : ""}",
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            )
          : const Text(
              "Deseja criar um novo evento?.",
              style: TextStyle(fontSize: 16),
            ),
    );
  }
}
