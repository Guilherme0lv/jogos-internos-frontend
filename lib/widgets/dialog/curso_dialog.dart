import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:projeto_web/controllers/curso_controller.dart';
import 'package:projeto_web/models/curso.dart';
import 'package:projeto_web/widgets/dialog/default_dialog_container.dart';
import 'package:projeto_web/widgets/dialog/generic_edit_dialog.dart';

class CursoDialog extends StatelessWidget {
  final Curso? curso;
  CursoDialog({super.key, this.curso}); 
  final cursoController = GetIt.instance<CursoController>();

  @override
  Widget build(BuildContext context) {
    final isEdicao = curso != null;

    return AlertDialog(
      title: Text(isEdicao ? "Informações do Curso" : "Novo Curso"),
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
                    titulo: isEdicao ? "Editar Curso" : "Criar Curso",
                    campos: {
                      "Nome": curso?.nome ?? "",
                      "Tipo": curso?.tipoCurso ?? "",
                    },
                    onSalvar: (valores) async {
                      final novoOuEditado = Curso(
                        nome: valores["Nome"]!,
                        tipoCurso: valores["Tipo"]!,
                      );
                      if (isEdicao) {
                        await cursoController.updateCurso(
                          novoOuEditado,
                          curso!.nome,
                        );
                      } else {
                        await cursoController.createCurso(novoOuEditado);
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
                  await cursoController.removeCurso(curso!.nome);
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
                      "Nome: ${curso!.nome}",
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                  DefaultDialogContainer(
                    child: Text(
                      "Tipo: ${curso!.tipoCurso}",
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            )
          : const Text(
              "Deseja criar um novo curso?.",
              style: TextStyle(fontSize: 16),
            ),
    );
  }
}
