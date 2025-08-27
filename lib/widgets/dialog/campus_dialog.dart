import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:projeto_web/controllers/campus_controller.dart';
import 'package:projeto_web/models/campus.dart';
import 'package:projeto_web/widgets/dialog/default_dialog_container.dart';
import 'package:projeto_web/widgets/dialog/generic_edit_dialog.dart';

class CampusDialog extends StatelessWidget {
  final Campus? campus;
  CampusDialog({super.key, this.campus});

  final campusController = GetIt.instance<CampusController>();

  @override
  Widget build(BuildContext context) {
    final isEdicao = campus != null;

    return AlertDialog(
      title: Text(isEdicao ? "Informações do Campus" : "Novo Campus"),
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
                    titulo: isEdicao ? "Editar Campus" : "Criar Campus",
                    campos: {
                      "Nome": campus?.nome ?? "",
                      "Cidade": campus?.cidade ?? "",
                    },
                    onSalvar: (valores) async {
                      final novoOuEditado = Campus(
                        nome: valores["Nome"]!,
                        cidade: valores["Cidade"]!,
                      );

                      if (isEdicao) {
                      
                        await campusController.updateCampus(
                          novoOuEditado,
                          campus!.nome,
                        );
                      } else {
                     
                        await campusController.createCampus(novoOuEditado);
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
                  await campusController.removeCampus(campus!.nome);
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
                      "Nome: ${campus!.nome}",
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                  DefaultDialogContainer(
                    child: Text(
                      "Cidade: ${campus!.cidade}",
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            )
          : const Text(
              "Deseja criar um novo campus?",
              style: TextStyle(fontSize: 16),
            ),
    );
  }
}
