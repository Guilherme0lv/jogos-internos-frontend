import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:projeto_web/controllers/curso_controller.dart';
import 'package:projeto_web/controllers/usuario_controller.dart';
import 'package:projeto_web/widgets/custom_footer.dart';
import 'package:projeto_web/widgets/dialog/curso_dialog.dart';

class CursoPage extends StatefulWidget {
  const CursoPage({super.key});

  @override
  State<CursoPage> createState() => _CursoPageState();
}

class _CursoPageState extends State<CursoPage> {
  final cursoController = GetIt.I<CursoController>();
  final usuarioController = GetIt.I<UsuarioController>();
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadCursos();
  }

  Future<void> _loadCursos() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      await cursoController.fetchCursos();
    } catch (e) {
      errorMessage = "Erro ao carregar cursos";
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
      appBar: AppBar(title: const Text("Cursos")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
          ? Center(child: Text(errorMessage!))
          : AnimatedBuilder(
              animation: cursoController,
              builder: (context, _) {
                final cursos = cursoController.cursos;
                if (cursos.isEmpty) {
                  return const Center(
                    child: Text(
                      "Nenhum curso cadastrado",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 80),
                  itemCount: cursos.length,
                  itemBuilder: (_, i) {
                    final curso = cursos[i];
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
                          curso.nome,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Text(
                          curso.tipoCurso,
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
                                      return CursoDialog(curso: curso);
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
                    return CursoDialog(curso: null);
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
