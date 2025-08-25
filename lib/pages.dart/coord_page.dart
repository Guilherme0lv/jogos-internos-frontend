import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:projeto_web/controllers/usuario_controller.dart';
import 'package:projeto_web/models/usuario.dart';
import 'package:projeto_web/widgets/custom_footer.dart';
import 'package:projeto_web/widgets/dialog/generic_edit_dialog.dart';

class CoordenadorPerfilPage extends StatefulWidget {
  const CoordenadorPerfilPage({super.key});

  @override
  State<CoordenadorPerfilPage> createState() => _CoordenadorPerfilPageState();
}

class _CoordenadorPerfilPageState extends State<CoordenadorPerfilPage> {
  final usuarioController = GetIt.I<UsuarioController>();
  Usuario? coordenador;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    coordenador = usuarioController.usuario;
    isLoading = coordenador == null;
  }

  void _editarPerfil() {
    if (coordenador == null) return;

    final campos = {
      'nomeCompleto': coordenador!.nomeCompleto,
      'cursoNome': coordenador!.cursoNome,
      'apelido': coordenador!.apelido,
      'telefone': coordenador!.telefone,
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
              matricula: coordenador!.matricula,
              nomeCompleto: dados['nomeCompleto']!,
              senha: coordenador!.senha, // Use a senha antiga
              cursoNome: dados['cursoNome']!,
              apelido: dados['apelido']!,
              telefone: dados['telefone']!,
              tipoUsuario: 'COORDENADOR',
            );

            await usuarioController.updateUser(
              atualizado,
              atualizado.matricula,
            );

            usuarioController.usuario = atualizado;
            setState(() => coordenador = atualizado);

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
    if (coordenador == null) return;

    final campos = {'senha': ''};

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
              matricula: coordenador!.matricula,
              nomeCompleto: coordenador!.nomeCompleto,
              senha: dados['senha']!,
              cursoNome: coordenador!.cursoNome,
              apelido: coordenador!.apelido,
              telefone: coordenador!.telefone,
              tipoUsuario: 'COORDENADOR',
            );

            await usuarioController.updateUser(
              atualizado,
              atualizado.matricula,
            );

            usuarioController.usuario = atualizado;
            setState(() => coordenador = atualizado);

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

  Future<void> _adicionarTecnico() async {
    final matriculaController = TextEditingController();

    final matricula = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Adicionar Técnico'),
          content: TextField(
            controller: matriculaController,
            decoration: const InputDecoration(
              labelText: 'Matricula do Técnico',
              border: OutlineInputBorder(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop(null);
              },
            ),
            ElevatedButton(
              child: const Text('Adicionar'),
              onPressed: () {
                final matricula = matriculaController.text;
                if (matricula.isEmpty) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('A matricula não pode ser vazia.'),
                      ),
                    );
                  }
                  return;
                }
                Navigator.of(context).pop(matricula);
              },
            ),
          ],
        );
      },
    );

    if (matricula == null) {
      return;
    }

    if (context.mounted) {
      setState(() => isLoading = true);
    }

    try {
      await usuarioController.definirTecnico(matricula);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Técnico adicionado com sucesso!')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao adicionar técnico: $e')),
        );
      }
    } finally {
      if (context.mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  Future<void> _obterLoginPorEmail() async {
    final matriculaController = TextEditingController();
    final matricula = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Obter Login por Email'),
          content: TextField(
            controller: matriculaController,
            decoration: const InputDecoration(
              labelText: 'Matricula do usuário',
              border: OutlineInputBorder(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop(null);
              },
            ),
            ElevatedButton(
              child: const Text('Enviar'),
              onPressed: () {
                final matricula = matriculaController.text;
                if (matricula.isEmpty) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('A matricula não pode ser vazia.'),
                      ),
                    );
                  }
                  return;
                }
                Navigator.of(context).pop(matricula);
              },
            ),
          ],
        );
      },
    );

    if (matricula == null) {
      return;
    }

    if (context.mounted) {
      setState(() => isLoading = true);
    }

    try {
      await usuarioController.enviarLogin(matricula);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login enviado para o email!')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erro ao enviar login: $e')));
      }
    } finally {
      if (context.mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil do Coordenador'),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : coordenador == null
          ? const Center(child: Text('Coordenador não encontrado'))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- Seção de Perfil ---
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
                          _buildProfileRow('Matrícula', coordenador!.matricula),
                          _buildProfileRow('Nome', coordenador!.nomeCompleto),
                          _buildProfileRow('Curso', coordenador!.cursoNome),
                          _buildProfileRow('Apelido', coordenador!.apelido),
                          _buildProfileRow('Telefone', coordenador!.telefone),
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
                  const SizedBox(height: 24),
                  // --- Seção de Ações do Coordenador ---
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
                            'Ações do Coordenador',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Divider(height: 20, thickness: 1.5),
                          _buildActionButton(
                            icon: Icons.person_add,
                            label: 'Adicionar Técnico',
                            onPressed: _adicionarTecnico,
                            color: Colors.green,
                          ),
                          const SizedBox(height: 10),
                          _buildActionButton(
                            icon: Icons.email,
                            label: 'Obter Login por Email',
                            onPressed: _obterLoginPorEmail,
                            color: Colors.orange,
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

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white),
        label: Text(label, style: const TextStyle(color: Colors.white)),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}
