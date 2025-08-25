import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:projeto_web/controllers/equipe_controller.dart';
import 'package:projeto_web/controllers/esporte_controller.dart';
import 'package:projeto_web/controllers/usuario_controller.dart';
import 'package:projeto_web/widgets/custom_footer.dart';
import 'package:projeto_web/widgets/dialog/equipe_create_dialog.dart';
import 'package:projeto_web/widgets/dialog/equipe_edit_dialog.dart';

class EquipePage extends StatefulWidget {
  const EquipePage({super.key});

  @override
  State<EquipePage> createState() => _EquipePageState();
}

class _EquipePageState extends State<EquipePage> {
  final esporteController = GetIt.I<EsporteController>();
  final equipeController = GetIt.I<EquipeController>();
  final usuarioController = GetIt.I<UsuarioController>();
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadEsportes();
  }

  Future<void> _loadEsportes() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      await esporteController.fetchEsportes();
    } catch (e) {
      errorMessage = "Erro ao carregar esportes";
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _abrirDialogEdicao(equipe) {
    showDialog(
      context: context,
      builder: (_) => EquipeEditDialog(
        equipe: equipe,
        onSave: (equipeAtualizada) async {
          await equipeController.updateEquipe(equipeAtualizada, equipe.nome);
          setState(() {});
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isAdmin = usuarioController.usuario?.tipoUsuario == "ADMIN";
    final bool isTecnico = usuarioController.usuario?.tipoUsuario == "TECNICO";
    return Scaffold(
      appBar: AppBar(title: const Text("Equipes por Esporte")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
          ? Center(child: Text(errorMessage!))
          : AnimatedBuilder(
              animation: esporteController,
              builder: (context, _) {
                final esportes = esporteController.esportes;

                if (esportes.isEmpty) {
                  return const Center(
                    child: Text(
                      "Nenhum esporte cadastrado",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: esportes.length,
                  itemBuilder: (_, i) {
                    final esporte = esportes[i];
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ExpansionTile(
                        title: Text(esporte.nome),
                        children: [
                          FutureBuilder(
                            future: equipeController.getEquipesByEsporte(
                              esporte.nome,
                            ),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              }
                              if (snapshot.hasError) {
                                return const Text("Erro ao carregar equipes");
                              }

                              final equipes = snapshot.data ?? [];

                              return Column(
                                children: [
                                  ...equipes.map(
                                    (equipe) => ListTile(
                                      title: Text(equipe.nome),
                                      subtitle: Text(
                                        "Curso: ${equipe.cursoNome} - Campus: ${equipe.campusNome} - Tecnico: ${equipe.tecnicoMatricula}",
                                      ),
                                      trailing: (() {
                                        // ADMIN pode sempre
                                        if (isAdmin)
                                          return IconButton(
                                            icon: const Icon(Icons.menu),
                                            onPressed: () =>
                                                _abrirDialogEdicao(equipe),
                                          );

                                        // TECNICO só se for do mesmo curso
                                        if (isTecnico &&
                                            usuarioController
                                                    .usuario
                                                    ?.cursoNome ==
                                                equipe.cursoNome) {
                                          return IconButton(
                                            icon: const Icon(Icons.menu),
                                            onPressed: () =>
                                                _abrirDialogEdicao(equipe),
                                          );
                                        }

                                        // Outros usuários não podem editar
                                        return null;
                                      })(),
                                    ),
                                  ),
                                  if (isAdmin || isTecnico)
                                    if (isAdmin || isTecnico)
                                      TextButton.icon(
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (_) => EquipeDialog(
                                              esporteSelecionado: esporte,
                                              onSave: (novaEquipe) async {
                                                try {
                                                  await equipeController
                                                      .createEquipe(novaEquipe);
                                                  if (mounted) {
                                                    ScaffoldMessenger.of(
                                                      context,
                                                    ).showSnackBar(
                                                      const SnackBar(
                                                        content: Text(
                                                          "Equipe criada com sucesso!",
                                                        ),
                                                        backgroundColor:
                                                            Colors.green,
                                                      ),
                                                    );
                                                  }
                                                  setState(() {});
                                                } catch (e) {
                                                  if (mounted) {
                                                    ScaffoldMessenger.of(
                                                      context,
                                                    ).showSnackBar(
                                                      SnackBar(
                                                        content: Text(
                                                          "Erro ao criar equipe: $e",
                                                        ),
                                                        backgroundColor:
                                                            Colors.red,
                                                      ),
                                                    );
                                                  }
                                                }
                                              },
                                            ),
                                          );
                                        },
                                        icon: const Icon(Icons.add),
                                        label: const Text("Adicionar Equipe"),
                                      ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
      bottomNavigationBar: CustomFooter(),
    );
  }
}
