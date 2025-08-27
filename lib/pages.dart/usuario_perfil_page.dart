import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:projeto_web/controllers/usuario_controller.dart';
import 'package:projeto_web/models/usuario.dart';
import 'package:projeto_web/widgets/custom_drawer.dart';
import 'package:projeto_web/widgets/custom_footer.dart';
import 'package:projeto_web/widgets/dialog/generic_edit_dialog.dart';

class UsuarioPerfilPage extends StatefulWidget {
  const UsuarioPerfilPage({super.key});

  @override
  State<UsuarioPerfilPage> createState() => _UsuarioPerfilPageState();
}

class _UsuarioPerfilPageState extends State<UsuarioPerfilPage> {
  final usuarioController = GetIt.I<UsuarioController>();
  Usuario? usuario;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    usuario = usuarioController.usuario;
    isLoading = usuario == null;
  }

  void _editarPerfil() {
    if (usuario == null) return;
    final campos = {
      'nomeCompleto': usuario!.nomeCompleto,
      'cursoNome': usuario!.cursoNome,
      'apelido': usuario!.apelido,
      'telefone': usuario!.telefone,
    };

    showDialog(
      context: context,
      builder: (context) => GenericEditDialog(
        titulo: 'Editar Perfil',
        campos: campos,
        onSalvar: (dados) async {
          setState(() => isLoading = true);
          try {
            final atualizado = Usuario(
              matricula: usuario!.matricula,
              nomeCompleto: dados['nomeCompleto']!,
              senha: usuario!.senha,
              cursoNome: dados['cursoNome']!,
              apelido: dados['apelido']!,
              telefone: dados['telefone']!,
              tipoUsuario: usuario!.tipoUsuario, 
            );

            await usuarioController.updateUser(
              atualizado,
              atualizado.matricula,
            );

            usuarioController.usuario = atualizado;
            setState(() => usuario = atualizado);

            if (context.mounted) Navigator.of(context).pop();
          } catch (e) {
            if (context.mounted) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Erro: $e')));
            }
          } finally {
            if (context.mounted) {
              setState(() => isLoading = false);
            }
          }
        },
      ),
    );
  }

  void _alterarSenha() {
    if (usuario == null) return;

    final campos = {
      'senha': '',
    };

    showDialog(
      context: context,
      builder: (context) => GenericEditDialog(
        titulo: 'Alterar Senha',
        campos: campos,
        onSalvar: (dados) async {
          setState(() => isLoading = true);
          try {
            if (dados['senha']!.isEmpty) {
              throw Exception('A senha não pode ser vazia');
            }

            final atualizado = Usuario(
              matricula: usuario!.matricula,
              nomeCompleto: usuario!.nomeCompleto,
              senha: dados['senha']!,
              cursoNome: usuario!.cursoNome,
              apelido: usuario!.apelido,
              telefone: usuario!.telefone,
              tipoUsuario: usuario!.tipoUsuario,
            );

            await usuarioController.updateUser(
              atualizado,
              atualizado.matricula,
            );

            usuarioController.usuario = atualizado;
            setState(() => usuario = atualizado);

            if (context.mounted) Navigator.of(context).pop();
          } catch (e) {
            if (context.mounted) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Erro: $e')));
            }
          } finally {
            if (context.mounted) {
              setState(() => isLoading = false);
            }
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(usuario: usuarioController.usuario),
      appBar: AppBar(
        title: const Text('Meu Perfil'),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : usuario == null
              ? const Center(child: Text('Usuário não encontrado'))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                
                      Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Dados do Perfil',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Divider(height: 20, thickness: 1.5),
                              _buildProfileRow(
                                  'Matrícula', usuario!.matricula),
                              _buildProfileRow('Nome', usuario!.nomeCompleto),
                              _buildProfileRow('Curso', usuario!.cursoNome),
                              _buildProfileRow('Apelido', usuario!.apelido),
                              _buildProfileRow('Telefone', usuario!.telefone),
                              const SizedBox(height: 16),
                              Center(
                                child: ElevatedButton.icon(
                                  onPressed: _editarPerfil,
                                  icon: const Icon(Icons.edit, color: Colors.white),
                                  label: const Text(
                                    'Editar Perfil',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Center(
                                child: ElevatedButton.icon(
                                  onPressed: _alterarSenha,
                                  icon: const Icon(Icons.lock, color: Colors.white),
                                  label: const Text(
                                    'Alterar Senha',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.orange,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
      bottomNavigationBar: const CustomFooter(),
    );
  }

  Widget _buildProfileRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 16))),
        ],
      ),
    );
  }
}
