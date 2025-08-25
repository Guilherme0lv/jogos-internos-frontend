import 'package:flutter/material.dart';
import 'package:projeto_web/pages.dart/cadastro_page.dart';
import 'package:projeto_web/pages.dart/campus_page.dart';
import 'package:projeto_web/pages.dart/campeonato_page.dart';
import 'package:projeto_web/pages.dart/coord_page.dart';
import 'package:projeto_web/pages.dart/curso_page.dart';
import 'package:projeto_web/pages.dart/equipe_page.dart';
import 'package:projeto_web/pages.dart/esporte_page.dart';
import 'package:projeto_web/pages.dart/evento_page.dart';
import 'package:projeto_web/pages.dart/home_page.dart';
import 'package:projeto_web/pages.dart/login_page.dart';
import 'package:projeto_web/pages.dart/usuario_page.dart';
import 'package:projeto_web/pages.dart/usuario_perfil_page.dart';
import 'package:projeto_web/routes/routes.dart';

Map<String, WidgetBuilder> routes = {
  Routes.homePage: (BuildContext context) =>
      MyHomePage(title: "Jogos Internos IFS"),
  Routes.login: (BuildContext context) => LoginPage(),
  Routes.usuarios: (BuildContext context) => UsuarioPage(),
  Routes.usuarioPerfil: (BuildContext context) => UsuarioPerfilPage(),
  Routes.cadastro: (BuildContext context) => CadastroPage(),
  Routes.cursos: (BuildContext context) => CursoPage(),
  Routes.esportes: (BuildContext context) => EsportePage(),
  Routes.campus: (BuildContext context) => CampusPage(),
  Routes.equipes: (BuildContext context) => EquipePage(),
  Routes.eventos: (BuildContext context) => EventoPage(),
  Routes.campeonatos: (BuildContext context) => CampeonatoPage(),
  Routes.coord: (BuildContext context) => CoordenadorPerfilPage(),
};
