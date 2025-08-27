import 'package:flutter/material.dart';
import 'package:projeto_web/models/usuario.dart';
import 'package:projeto_web/routes/routes.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key, this.usuario});
  final Usuario? usuario;

  @override
  Widget build(BuildContext context) {
    return Drawer(
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
              leading: const Icon(Icons.emoji_events),
              title: const Text('Campeonato'),
              onTap: () {
                Navigator.of(
                  context,
                ).pushNamed(Routes.campeonatos);
              },
            ),
            ListTile(
              leading: const Icon(Icons.groups),
              title: const Text('Equipes'),
              onTap: () {
                Navigator.of(
                  context,
                ).pushNamed(Routes.equipes);
              },
            ),
            ListTile(
              leading: const Icon(Icons.school),
              title: const Text('Cursos'),
              onTap: () {
                Navigator.of(
                  context,
                ).pushNamed(Routes.cursos);
              },
            ),
            ListTile(
              leading: const Icon(Icons.location_city),
              title: const Text('Campus'),
              onTap: () {
                Navigator.of(
                  context,
                ).pushNamed(Routes.campus);
              },
            ),
            ListTile(
              leading: const Icon(Icons.sports_baseball),
              title: const Text('Esportes'),
              onTap: () {
                Navigator.of(
                  context,
                ).pushNamed(Routes.esportes);
              },
            ),
            ListTile(
              leading: const Icon(Icons.event),
              title: const Text('Eventos'),
              onTap: () {
                Navigator.of(
                  context,
                ).pushNamed(Routes.eventos);
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
      );
  }
}