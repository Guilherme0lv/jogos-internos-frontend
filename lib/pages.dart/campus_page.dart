import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:projeto_web/controllers/campus_controller.dart';
import 'package:projeto_web/controllers/usuario_controller.dart';
import 'package:projeto_web/widgets/custom_footer.dart';
import 'package:projeto_web/widgets/dialog/campus_dialog.dart';

class CampusPage extends StatefulWidget {
  const CampusPage({super.key});

  @override
  State<CampusPage> createState() => _CampusPageState();
}

class _CampusPageState extends State<CampusPage> {
  final campusController = GetIt.I<CampusController>();
  final usuarioController = GetIt.I<UsuarioController>();

  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadCampus();
  }

  Future<void> _loadCampus() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      await campusController.fetchCampi();
    } catch (e) {
      errorMessage = "Erro ao carregar campus";
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
      appBar: AppBar(title: const Text("Campus")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
          ? Center(child: Text(errorMessage!))
          : AnimatedBuilder(
              animation: campusController,
              builder: (context, _) {
                final campi = campusController.campi;
                if (campi.isEmpty) {
                  return const Center(
                    child: Text(
                      "Nenhum campus cadastrado",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 80),
                  itemCount: campi.length,
                  itemBuilder: (_, i) {
                    final campus = campi[i];
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
                          campus.nome,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Text(
                          campus.cidade,
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: 14,
                          ),
                        ),
                        // Ícone de edição só para ADMIN
                        trailing: isAdmin
                            ? IconButton(
                                icon: const Icon(Icons.menu),
                                onPressed: () {
                                  showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (context) {
                                      return CampusDialog(campus: campus);
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
      // Botão de adicionar só para ADMIN
      floatingActionButton: isAdmin
          ? FloatingActionButton(
              onPressed: () {
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) {
                    return CampusDialog(campus: null);
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
