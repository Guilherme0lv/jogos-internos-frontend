import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:projeto_web/controllers/usuario_controller.dart';
import 'package:projeto_web/routes/routes.dart';
import 'package:projeto_web/widgets/custom_drawer.dart';
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
      drawer: CustomDrawer(usuario: usuario),
      appBar: AppBar(
        backgroundColor: Colors.green,
        titleTextStyle: const TextStyle(fontSize: 20, color: Colors.white),
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(widget.title),
      ),
      backgroundColor: Colors.grey[200], 
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
      
        _buildElevatedButton(
          context,
          rotasPermitidas[0]["label"]!,
          rotasPermitidas[0]["route"]!,
          isLarge: true,
        ),
        const SizedBox(height: 16),
     
        Wrap(
          spacing: 16.0,
          runSpacing: 16.0,
          alignment: WrapAlignment.center,
          children: rotasPermitidas
              .skip(1) 
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
          elevation: 10, 
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
        return Icons.sports_baseball;
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
