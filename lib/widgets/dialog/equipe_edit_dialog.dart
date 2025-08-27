import 'package:flutter/material.dart';
import 'package:projeto_web/models/equipe.dart';

class EquipeEditDialog extends StatefulWidget {
  final Equipe equipe;
  final Future<void> Function(Equipe equipe) onSave;

  const EquipeEditDialog({
    super.key,
    required this.equipe,
    required this.onSave,
  });

  @override
  State<EquipeEditDialog> createState() => _EquipeEditDialogState();
}

class _EquipeEditDialogState extends State<EquipeEditDialog> {
  late TextEditingController nomeController;
  late TextEditingController cursoController;
  late TextEditingController campusController;
  late TextEditingController tecnicoController;
  late TextEditingController atletasController;

  @override
  void initState() {
    super.initState();
    nomeController = TextEditingController(text: widget.equipe.nome);
    cursoController = TextEditingController(text: widget.equipe.cursoNome);
    campusController = TextEditingController(text: widget.equipe.campusNome);
    tecnicoController = TextEditingController(
      text: widget.equipe.tecnicoMatricula,
    );
    atletasController = TextEditingController(
      text: widget.equipe.atletasMatricula.join(", "),
    );
  }

  @override
  void dispose() {
    nomeController.dispose();
    cursoController.dispose();
    campusController.dispose();
    tecnicoController.dispose();
    atletasController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Editar Equipe"),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: nomeController,
              decoration: const InputDecoration(labelText: "Nome da Equipe"),
            ),
            TextField(
              controller: cursoController,
              decoration: const InputDecoration(labelText: "Curso"),
            ),
            TextField(
              controller: campusController,
              decoration: const InputDecoration(labelText: "Campus"),
            ),
            TextField(
              controller: tecnicoController,
              decoration: const InputDecoration(
                labelText: "Matrícula do Técnico",
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancelar"),
        ),
        ElevatedButton(
          onPressed: () async {
            final equipeAtualizada = Equipe(
              nome: nomeController.text,
              cursoNome: cursoController.text,
              campusNome: campusController.text,
              tecnicoMatricula: tecnicoController.text,
              esporteNome: widget.equipe.esporteNome,
              atletasMatricula: atletasController.text
                  .split(",") 
                  .map((a) => a.trim()) 
                  .where((a) => a.isNotEmpty) 
                  .toList(),
            );

            await widget.onSave(equipeAtualizada);
            if (context.mounted) Navigator.pop(context);
          },
          child: const Text("Salvar"),
        ),
      ],
    );
  }
}
