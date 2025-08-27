import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:projeto_web/controllers/usuario_controller.dart';
import 'package:projeto_web/widgets/custom_drawer.dart';
import 'package:projeto_web/widgets/custom_footer.dart';
import 'package:projeto_web/widgets/dialog/usuario_dialog.dart';

class UsuarioPage extends StatefulWidget {
  const UsuarioPage({super.key});

  @override
  State<UsuarioPage> createState() => _UsuarioPageState();
}

class _UsuarioPageState extends State<UsuarioPage> {
  final usuarioController = GetIt.I<UsuarioController>();
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      await usuarioController.fetchUsers();
    } catch (e) {
      errorMessage = "Erro ao carregar usuários";
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(usuario: usuarioController.usuario),
      appBar: AppBar(title: const Text("Usuários")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
          ? Center(child: Text(errorMessage!))
          : AnimatedBuilder(
              animation: usuarioController,
              builder: (context, _) {
                final users = usuarioController.users;
                if (users.isEmpty) {
                  return const Center(
                    child: Text(
                      "Nenhuma pessoa encontrada",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: users.length,
                  itemBuilder: (_, i) {
                    final user = users[i];
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
                        leading: CircleAvatar(
                          radius: 28,
                          backgroundColor: Colors.blue.shade100,
                          child: Text(
                            user.nomeCompleto.isNotEmpty
                                ? user.nomeCompleto[0]
                                : "?",
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                        title: Text(
                          user.nomeCompleto,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Text(
                          user.apelido,
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: 14,
                          ),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.menu),
                          onPressed: () {
                            showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) {
                                return UsuarioDialog(usuario: user);
                              },
                            );
                          },
                        ),
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
