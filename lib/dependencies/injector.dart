import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:projeto_web/controllers/campus_controller.dart';
import 'package:projeto_web/controllers/curso_controller.dart';
import 'package:projeto_web/controllers/equipe_controller.dart';
import 'package:projeto_web/controllers/esporte_controller.dart';
import 'package:projeto_web/controllers/evento_controller.dart';
import 'package:projeto_web/controllers/grupo_controller.dart';
import 'package:projeto_web/controllers/jogo_controller.dart';
import 'package:projeto_web/controllers/login_controller.dart';
import 'package:projeto_web/controllers/usuario_controller.dart';
import 'package:projeto_web/services/campus_service.dart';
import 'package:projeto_web/services/curso_service.dart';
import 'package:projeto_web/services/equipe_service.dart';
import 'package:projeto_web/services/esporte_service.dart';
import 'package:projeto_web/services/evento_service.dart';
import 'package:projeto_web/services/grupo_service.dart';
import 'package:projeto_web/services/jogo_service.dart';
import 'package:projeto_web/services/login_service.dart';
import 'package:projeto_web/services/usuario_service.dart';

Future<void> injector() async {
  final i = GetIt.instance;

  i.registerSingleton<CampusService>(
    CampusService(dio: Dio(), apiUrl: 'http://localhost:8080/campus'),
  );

  i.registerSingleton<CampusController>(
    CampusController(campusService: i<CampusService>()),
  );

  i.registerSingleton<CursoService>(
    CursoService(dio: Dio(), apiUrl: 'http://localhost:8080/curso'),
  );

  i.registerSingleton<CursoController>(
    CursoController(cursoService: i<CursoService>()),
  );

  i.registerSingleton<LoginService>(
    LoginService(dio: Dio(), apiUrl: 'http://localhost:8080/auth'),
  );

  i.registerSingleton<LoginController>(
    LoginController(loginService: i<LoginService>()),
  );

  i.registerSingleton<UsuarioService>(
    UsuarioService(dio: Dio(), apiUrl: 'http://localhost:8080'),
  );

  i.registerSingleton<UsuarioController>(
    UsuarioController(usuarioService: i<UsuarioService>()),
  );

  i.registerSingleton<EsporteService>(
    EsporteService(dio: Dio(), apiUrl: 'http://localhost:8080/esporte'),
  );

  i.registerSingleton<EsporteController>(
    EsporteController(esporteService: i<EsporteService>()),
  );

  i.registerSingleton<EventoService>(
    EventoService(dio: Dio(), apiUrl: 'http://localhost:8080/evento'),
  );

  i.registerSingleton<EventoController>(
    EventoController(eventoService: i<EventoService>()),
  );

  i.registerSingleton<EquipeService>(
    EquipeService(dio: Dio(), apiUrl: 'http://localhost:8080/equipe'),
  );

  i.registerSingleton<EquipeController>(
    EquipeController(equipeService: i<EquipeService>()),
  );

   i.registerSingleton<GrupoService>(
    GrupoService(dio: Dio(), apiUrl: 'http://localhost:8080/grupo'),
  );

  i.registerSingleton<GrupoController>(
    GrupoController(grupoService: i<GrupoService>()),
  );

  i.registerSingleton<JogoService>(
    JogoService(dio: Dio(), apiUrl: 'http://localhost:8080'),
  );

  i.registerSingleton<JogoController>(
    JogoController(jogoService: i<JogoService>()),
  );
}
