import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:projeto_web/controllers/esporte_controller.dart';
import 'package:projeto_web/controllers/usuario_controller.dart';
import 'package:projeto_web/widgets/custom_drawer.dart';
import 'package:projeto_web/widgets/custom_footer.dart';
import 'package:projeto_web/widgets/dialog/esporte_dialog.dart';

class EsportePage extends StatefulWidget {
  const EsportePage({super.key});

  @override
  State<EsportePage> createState() => _EsportePageState();
}

class _EsportePageState extends State<EsportePage> {
  final esporteController = GetIt.I<EsporteController>();
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
      errorMessage = "Erro ao carregar Esportes";
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isAdmin = usuarioController.usuario?.tipoUsuario == "ADMIN";
    return Scaffold(
      drawer: CustomDrawer(usuario: usuarioController.usuario),
      appBar: AppBar(title: const Text("Esportes")),
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
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 80),
                  itemCount: esportes.length,
                  itemBuilder: (_, i) {
                    final esporte = esportes[i];
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        title: Text(
                          esporte.nome.toString(),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Text(
                          'Evento: ${esporte.evento.toString()} - Min. Atletas: ${esporte.minAtletas} - Max. Atletas: ${esporte.maxAtletas}',
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: 14,
                          ),
                        ),
                        trailing: isAdmin
                            ? IconButton(
                                icon: const Icon(Icons.menu),
                                onPressed: () {
                                  showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (context) {
                                      return EsporteDialog(esporte: esporte);
                                    },
                                  );
                                },
                              )
                            : null,
                      ),
                    );
                  },
                );
              },
            ),
      floatingActionButton: isAdmin
          ? FloatingActionButton(
              onPressed: () {
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) {
                    return EsporteDialog(esporte: null);
                  },
                );
              },
              child: const Icon(Icons.add),
            )
          : null,
      bottomNavigationBar: CustomFooter(),
    );
  }
}
