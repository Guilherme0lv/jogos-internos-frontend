
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:projeto_web/controllers/usuario_controller.dart';
import 'package:projeto_web/models/usuario.dart';
import 'package:projeto_web/widgets/custom_footer.dart';

class CadastroPage extends StatefulWidget {
  const CadastroPage({super.key});

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final _formKey = GlobalKey<FormState>();
  final usuarioController = GetIt.I<UsuarioController>();

  final TextEditingController matriculaController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController apelidoController = TextEditingController();
  final TextEditingController telefoneController = TextEditingController();
  final TextEditingController tipoUsuarioController = TextEditingController();
  final TextEditingController cursoController = TextEditingController();

  @override
  void dispose() {
    matriculaController.dispose();
    senhaController.dispose();
    nomeController.dispose();
    apelidoController.dispose();
    telefoneController.dispose();
    tipoUsuarioController.dispose();
    cursoController.dispose();
    super.dispose();
  }

  void _cadastrar() {
    if (_formKey.currentState!.validate()) {
      final usuario = Usuario(
        matricula: matriculaController.text,
        senha: senhaController.text,
        nomeCompleto: nomeController.text,
        apelido: apelidoController.text,
        telefone: telefoneController.text,
        tipoUsuario: tipoUsuarioController.text,
        cursoNome: cursoController.text,
      );

      try {
        usuarioController.addUser(usuario);

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Cadastro realizado!")));

        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Erro ao cadastrar usuario. Tente novamente. ${e.toString()}"),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cadastrar Usuário")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: matriculaController,
                decoration: const InputDecoration(labelText: "Matrícula"),
                validator: (value) =>
                    value!.isEmpty ? "Campo obrigatório" : null,
              ),
              TextFormField(
                controller: senhaController,
                decoration: const InputDecoration(labelText: "Senha"),
                obscureText: true,
                validator: (value) =>
                    value!.isEmpty ? "Campo obrigatório" : null,
              ),
              TextFormField(
                controller: nomeController,
                decoration: const InputDecoration(labelText: "Nome"),
                validator: (value) =>
                    value!.isEmpty ? "Campo obrigatório" : null,
              ),
              TextFormField(
                controller: apelidoController,
                decoration: const InputDecoration(labelText: "Apelido"),
              ),
              TextFormField(
                controller: telefoneController,
                decoration: const InputDecoration(labelText: "Telefone"),
              ),
              TextFormField(
                controller: tipoUsuarioController,
                decoration: const InputDecoration(labelText: "Tipo de Usuário"),
              ),
              TextFormField(
                controller: cursoController,
                decoration: const InputDecoration(labelText: "Curso"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _cadastrar,
                child: const Text("Cadastrar"),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomFooter(),
    );
  }
}
