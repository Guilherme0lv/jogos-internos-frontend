import 'package:flutter/material.dart';
import 'package:projeto_web/models/usuario.dart';
import 'package:projeto_web/services/usuario_service.dart';

class UsuarioController extends ChangeNotifier {
  final UsuarioService usuarioService;
  Usuario? usuario;

  void setUsuario(Usuario u) {
    usuario = u;
  }

  String get tipoUsuario => usuario?.tipoUsuario ?? "";

  UsuarioController({required this.usuarioService});

  List<Usuario> users = [];
  bool isLoading = false;

  Future<void> fetchUsers() async {
    try {
      users = await usuarioService.getUsers();
    } catch (e) {
      debugPrint("Erro ao buscar usuários: $e");
      users = []; 
    }
  }

  Future<List<Usuario>> getUsers() async {
    return await usuarioService.getUsers();
  }

  Future<List<Usuario>> getTecnicos() async {
    return await usuarioService.getTecnicos();
  }

  Future<List<Usuario>> getAtletas() async {
    return await usuarioService.getAtletas();
  }

  Future<Usuario> getUsuariosByMatricula(String matricula) async {
    return await usuarioService.getUserByMatricula(matricula);
  }

  Future<void> addUser(Usuario user) async {
    try {
      final newUser = await usuarioService.createUser(user);
      users.add(newUser);
      notifyListeners();
    } catch (e) {
      throw Exception("Dados inválidos. Tente novamente. ${e.toString()}");
    } finally {
      notifyListeners();
    }
  }

  Future<void> updateUser(Usuario user, String matricula) async {
    final updated = await usuarioService.updateUser(user, matricula);
    final index = users.indexWhere((u) => u.matricula == user.matricula);
    if (index != -1) {
      users[index] = updated;
      notifyListeners();
    }
  }

  Future<void> removeUser(String matricula) async {
    try {
      await usuarioService.deleteUser(matricula);
      users.removeWhere((u) => u.matricula == matricula);
    } catch (e) {
      debugPrint("Erro ao deletar usuário: $e");
    } finally {
      notifyListeners();
    }
  }

  Future<String> createCoord(Usuario coordenador) async {
    try {
      final response = await usuarioService.createCoord(coordenador);
      return response.toString();
    } catch (e) {
      throw Exception("Dados inválidos. Tente novamente. ${e.toString()}");
    }
  }

  Future<String> definirTecnico(String usuarioMatricula) async {
    final response = await usuarioService.definirTecnico(usuarioMatricula);
    return response;
  }

  Future<String> enviarLogin(String coordenadorMatricula) async {
    final response = await usuarioService.enviarLogin(coordenadorMatricula);
    return response;
  }
}
