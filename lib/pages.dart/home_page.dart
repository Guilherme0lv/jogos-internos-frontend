import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:projeto_web/controllers/usuario_controller.dart';
import 'package:projeto_web/routes/routes.dart';
import 'package:projeto_web/widgets/custom_footer.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final usuarioController = GetIt.I<UsuarioController>();
    final usuario = usuarioController.usuario;
    final tipo = usuario?.tipoUsuario ?? "";

    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.green),
              child: Row(
                children: [
                  const Icon(Icons.person, color: Colors.white, size: 40),
                  const SizedBox(width: 10),
                  Text(
                    usuario?.nomeCompleto ?? "Usuário",
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                if (ModalRoute.of(context)?.settings.name == Routes.homePage) {
                  Navigator.of(context).pop();
                } else {
                  Navigator.of(
                    context,
                  ).pushNamedAndRemoveUntil(Routes.homePage, (route) => false);
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Sair'),
              onTap: () {
                Navigator.of(
                  context,
                ).pushNamedAndRemoveUntil(Routes.login, (route) => false);
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.green,
        titleTextStyle: const TextStyle(fontSize: 20, color: Colors.white),
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(widget.title),
      ),
      backgroundColor: Colors.grey[200], // Fundo cinza claro
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [_buildCustomCards(tipo)],
          ),
        ),
      ),
      bottomNavigationBar: CustomFooter(),
    );
  }

  /// Decide os cards com base no tipo de usuário
  Widget _buildCustomCards(String tipoUsuario) {
    final rotasBasicas = [
      {"label": "Campeonato", "route": Routes.campeonatos},
      {"label": "Equipes", "route": Routes.equipes},
      {"label": "Cursos", "route": Routes.cursos},
      {"label": "Campus", "route": Routes.campus},
      {"label": "Esportes", "route": Routes.esportes},
      {"label": "Eventos", "route": Routes.eventos},
    ];
    final rotasAtleta = [
      {"label": "Área do Atleta", "route": Routes.usuarioPerfil},
    ];

    final rotasCoord = [
      {"label": "Área do Coordenador", "route": Routes.coord},
    ];

    List<Map<String, String>> rotasPermitidas = List.from(rotasBasicas);
    if (tipoUsuario == "COORDENADOR" || tipoUsuario == "ADMIN") {
      rotasPermitidas.addAll(rotasCoord);
    }

    if (tipoUsuario != "COORDENADOR") {
      rotasPermitidas.addAll(rotasAtleta);
    }

    return Column(
      children: [
        // Botão de Campeonatos em destaque
        _buildElevatedButton(
          context,
          rotasPermitidas[0]["label"]!,
          rotasPermitidas[0]["route"]!,
          isLarge: true,
        ),
        const SizedBox(height: 16),
        // Demais botões em grid
        Wrap(
          spacing: 16.0,
          runSpacing: 16.0,
          alignment: WrapAlignment.center,
          children: rotasPermitidas
              .skip(1) // Ignora o primeiro item (Campeonatos)
              .map(
                (r) => _buildElevatedButton(context, r["label"]!, r["route"]!),
              )
              .toList(),
        ),
      ],
    );
  }

  Widget _buildElevatedButton(
    BuildContext context,
    String text,
    String route, {
    bool isLarge = false,
  }) {
    return SizedBox(
      width: isLarge ? double.infinity : 160,
      height: isLarge ? 150 : 120,
      child: ElevatedButton(
        onPressed: () => Navigator.of(context).pushNamed(route),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.green[800],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          elevation: 6, // Adiciona sombra
          padding: const EdgeInsets.all(16.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _getIconForRoute(text),
              size: isLarge ? 48 : 32,
              color: Colors.green,
            ),
            const SizedBox(height: 8),
            Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: isLarge ? 20.0 : 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.green[800],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper para retornar um ícone com base no texto
  IconData _getIconForRoute(String text) {
    switch (text) {
      case "Campeonato":
        return Icons.emoji_events;
      case "Equipes":
        return Icons.group;
      case "Cursos":
        return Icons.school;
      case "Campus":
        return Icons.location_city;
      case "Esportes":
        return Icons.sports;
      case "Eventos":
        return Icons.event;
      case "Área do Coordenador":
        return Icons.shield;
      case "Área do Atleta":
        return Icons.person;
      default:
        return Icons.circle;
    }
  }
}
