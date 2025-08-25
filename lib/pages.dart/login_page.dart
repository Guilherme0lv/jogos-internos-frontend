import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:projeto_web/controllers/login_controller.dart';
import 'package:projeto_web/controllers/usuario_controller.dart';
import 'package:projeto_web/dto/login_dto.dart';
import 'package:projeto_web/routes/routes.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController matriculaController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();
  final LoginController loginController = GetIt.instance();
  final UsuarioController usuarioController = GetIt.instance();

  @override
  void initState() {
    super.initState();
  }

  void _fazerLogin() async {
    final usuario = await loginController.login(
      LoginDTO(
        matricula: matriculaController.text,
        senha: senhaController.text,
      ),
    );

    if (usuario != null) {
      usuarioController.setUsuario(usuario);
      Navigator.pushNamedAndRemoveUntil(context, Routes.homePage, (Route<dynamic> route) => false,);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Email ou senha inválidos")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: 350, // <-- controla a largura do "card"
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.lock, size: 80, color: Colors.green.shade700),
                  const SizedBox(height: 24),
                  Text(
                    "Bem-vindo",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade800,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),

                  // Campo login
                  TextFormField(
                    controller: matriculaController,
                    decoration: const InputDecoration(
                      labelText: "Login",
                      prefixIcon: Icon(Icons.person),
                    ),
                    validator: (value) => value == null || value.isEmpty
                        ? "Digite seu login"
                        : null,
                  ),
                  const SizedBox(height: 16),

                  // Campo senha
                  TextFormField(
                    controller: senhaController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: "Senha",
                      prefixIcon: Icon(Icons.lock),
                    ),
                    validator: (value) => value == null || value.isEmpty
                        ? "Digite sua senha"
                        : null,
                  ),
                  const SizedBox(height: 24),

                  // Botão login
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _fazerLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Entrar",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Botão cadastro
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(Routes.cadastro);
                    },
                    child: const Text(
                      "Cadastrar-se",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      backgroundColor: Colors.green.shade50, // fundo verdinho suave
    );
  }

  @override
  void dispose() {
    matriculaController.dispose();
    senhaController.dispose();
    super.dispose();
  }
}
