import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GenericEditDialog extends StatefulWidget {
  final String titulo;
  final Map<String, String> campos;
  final Future<void> Function(Map<String, String>) onSalvar;

  const GenericEditDialog({
    super.key,
    required this.titulo,
    required this.campos,
    required this.onSalvar,
  });

  @override
  State<GenericEditDialog> createState() => _GenericEditDialogState();
}

class _GenericEditDialogState extends State<GenericEditDialog> {
  final _formKey = GlobalKey<FormState>();
  late Map<String, TextEditingController> _controllers;
  bool _isPasswordVisible = false;
  final DateFormat displayFormat = DateFormat("dd/MM/yyyy");

  @override
  void initState() {
    super.initState();
    _controllers = widget.campos.map(
      (key, value) => MapEntry(key, TextEditingController(text: value)),
    );
  }

  @override
  void dispose() {
    for (var c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _selecionarData(
    BuildContext context,
    TextEditingController controller,
  ) async {
    DateTime? inicial;
    if (controller.text.isNotEmpty) {
      try {
        inicial = displayFormat.parse(controller.text);
      } catch (_) {
        inicial = DateTime.now();
      }
    }

    final selecionada = await showDatePicker(
      context: context,
      initialDate: inicial ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (selecionada != null) {
      controller.text = displayFormat.format(selecionada);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.titulo),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: _controllers.keys.map((key) {
              final isDateField = key.toLowerCase().contains("data");
              final isPasswordField = key == 'senha';
              final isReadOnly = key == 'matricula';

              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: TextFormField(
                  controller: _controllers[key],
                  decoration: InputDecoration(
                    labelText: key[0].toUpperCase() + key.substring(1),
                    border: const OutlineInputBorder(),
                    suffixIcon: isPasswordField
                        ? IconButton(
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          )
                        : null,
                  ),
                  readOnly: isDateField || isReadOnly,
                  obscureText: isPasswordField && !_isPasswordVisible,
                  onTap: isDateField
                      ? () => _selecionarData(context, _controllers[key]!)
                      : null,
                ),
              );
            }).toList(),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Cancelar"),
        ),
        ElevatedButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              final novosValores = _controllers.map(
                (key, controller) => MapEntry(key, controller.text),
              );

              try {
                await widget.onSalvar(novosValores);
                if (context.mounted) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Salvo com sucesso")),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Erro ao salvar: ${e.toString()}")),
                  );
                }
              }
            }
          },
          child: const Text("Salvar"),
        ),
      ],
    );
  }
}
