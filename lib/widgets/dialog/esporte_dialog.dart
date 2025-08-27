import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:projeto_web/controllers/esporte_controller.dart';
import 'package:projeto_web/models/esporte.dart';
import 'package:projeto_web/widgets/dialog/default_dialog_container.dart';
import 'package:projeto_web/widgets/dialog/generic_edit_dialog.dart';

class EsporteDialog extends StatelessWidget {
  EsporteDialog({super.key, this.esporte});
  final Esporte? esporte;

  final esporteController = GetIt.instance<EsporteController>();

  @override
  Widget build(BuildContext context) {
    final isEdicao = esporte != null;

    return AlertDialog(
      title: Text(isEdicao ? "Informações do Esporte" : "Novo Esporte"),
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
                    titulo: isEdicao ? "Editar Esporte" : "Criar Esporte",
                    campos: {
                      "Nome": esporte?.nome.toString() ?? "",
                      "Evento": esporte?.evento.toString() ?? "",
                      "MinAtletas": esporte?.minAtletas.toString() ?? "",
                      "MaxAtletas": esporte?.maxAtletas.toString() ?? "",
                    },
                    onSalvar: (valores) async {
                      final novoOuEditado = Esporte(
                        nome: valores["Nome"]!,
                        evento: valores["Evento"]!,
                        minAtletas: int.parse(valores["MinAtletas"]!),
                        maxAtletas: int.parse(valores["MaxAtletas"]!),
                      );

                      if (isEdicao) {
                        await esporteController.updateEsporte(novoOuEditado, esporte!.nome);
                      } else {
                        await esporteController.createEsporte(novoOuEditado);
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
                  await esporteController.removeEsporte(esporte!.nome);
                  Navigator.of(
                    context,
                  ).pop(); 
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
                      "Nome: ${esporte!.nome}",
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                  DefaultDialogContainer(
                    child: Text(
                      "Evento: ${esporte!.evento}",
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                  DefaultDialogContainer(
                    child: Text(
                      "Min. Atletas: ${esporte!.minAtletas}",
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                  DefaultDialogContainer(
                    child: Text(
                      "Max. Atletas: ${esporte!.maxAtletas}",
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                  DefaultDialogContainer(
                    child: Text(
                      "Campeao: ${esporte!.campeao}",
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            )
          : const Text(
              "Deseja criar um novo esporte?.",
              style: TextStyle(fontSize: 16),
            ),
    );
  }
}
