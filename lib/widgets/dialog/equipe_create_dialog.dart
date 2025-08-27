import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:projeto_web/controllers/campus_controller.dart';
import 'package:projeto_web/controllers/curso_controller.dart';
import 'package:projeto_web/controllers/esporte_controller.dart';
import 'package:projeto_web/controllers/usuario_controller.dart';
import 'package:projeto_web/models/campus.dart';
import 'package:projeto_web/models/curso.dart';
import 'package:projeto_web/models/equipe.dart';
import 'package:projeto_web/models/esporte.dart';

class EquipeDialog extends StatefulWidget {
  final void Function(Equipe) onSave;
   final Esporte esporteSelecionado; 

  const EquipeDialog({super.key, required this.onSave, required this.esporteSelecionado});

  @override
  State<EquipeDialog> createState() => _EquipeDialogState();
}

class _EquipeDialogState extends State<EquipeDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _tecnicoController = TextEditingController();
  final _atletasController = TextEditingController();

  String? _cursoSelecionado;
  String? _campusSelecionado;

  final cursoController = GetIt.I<CursoController>();
  final esporteController = GetIt.I<EsporteController>();
  final campusController = GetIt.I<CampusController>();
  final usuarioController = GetIt.I<UsuarioController>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Cadastrar Equipe"),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
    
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(labelText: "Nome da Equipe"),
                validator: (v) => v == null || v.isEmpty ? "Obrigatório" : null,
              ),
              const SizedBox(height: 12),

            
              FutureBuilder<List<Curso>>(
                future: cursoController.getCursos(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return const CircularProgressIndicator();
                  final cursos = snapshot.data!;
                  return DropdownButtonFormField<String>(
                    value: _cursoSelecionado,
                    items: cursos
                        .map(
                          (c) => DropdownMenuItem(
                            value: c.nome,
                            child: Text(c.nome),
                          ),
                        )
                        .toList(),
                    onChanged: (v) => setState(() => _cursoSelecionado = v),
                    decoration: const InputDecoration(labelText: "Curso"),
                    validator: (v) => v == null ? "Selecione um curso" : null,
                  );
                },
              ),
              const SizedBox(height: 12),
              FutureBuilder<List<Campus>>(
                future: campusController.getCampi(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator();
                  }
                  final campi = snapshot.data!;
                  return DropdownButtonFormField<String>(
                    initialValue: _campusSelecionado,
                    items: campi
                        .map(
                          (c) => DropdownMenuItem(
                            value: c.nome,
                            child: Text("${c.nome} - ${c.cidade}"),
                          ),
                        )
                        .toList(),
                    onChanged: (v) => setState(() => _campusSelecionado = v),
                    decoration: const InputDecoration(labelText: "Campus"),
                    validator: (v) => v == null ? "Selecione um campus" : null,
                  );
                },
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _tecnicoController,
                decoration: const InputDecoration(
                  labelText: "Matrícula do Técnico",
                ),
              ),
              TextField(
                controller: _atletasController,
                decoration: const InputDecoration(
                  labelText: "Atletas (separe por vírgulas: 123, 456...)",
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancelar"),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final equipe = Equipe(
                nome: _nomeController.text.trim(),
                cursoNome: _cursoSelecionado!,
                esporteNome:  widget.esporteSelecionado.nome,
                campusNome: _campusSelecionado!,
                tecnicoMatricula: _tecnicoController.text,
                atletasMatricula: _atletasController.text
                    .split(",") 
                    .map((a) => a.trim())
                    .where((a) => a.isNotEmpty) 
                    .toList(),
              );
              widget.onSave(equipe);
              Navigator.pop(context);
            }
          },
          child: const Text("Salvar"),
        ),
      ],
    );
  }
}