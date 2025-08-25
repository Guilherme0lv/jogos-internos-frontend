import 'package:dio/dio.dart';
import 'package:projeto_web/models/usuario.dart';

class UsuarioService {
  final Dio dio;
  final String apiUrl;

  UsuarioService({required this.dio, required this.apiUrl});

  Future<List<Usuario>> getUsers() async {
    final response = await dio.get('$apiUrl/usuario');
    if (response.statusCode == 200) {
      return (response.data as List).map((u) => Usuario.fromJson(u)).toList();
    } else {
      throw Exception("Erro ao buscar usuários");
    }
  }

  Future<Usuario> getUserByMatricula(String matricula) async {
    final response = await dio.get('$apiUrl/usuario/matricula/$matricula');
    return Usuario.fromJson(response.data);
  }

  Future<List<Usuario>> getTecnicos() async {
    String tipo = 'TECNICO';
    final response = await dio.get('$apiUrl/usuario/tipo/$tipo');
    return (response.data as List).map((u) => Usuario.fromJson(u)).toList();
  }

  Future<List<Usuario>> getAtletas() async {
    String tipo = 'ATLETA';
    final response = await dio.get('$apiUrl/usuario/tipo/$tipo');
    return (response.data as List).map((u) => Usuario.fromJson(u)).toList();
  }

  Future<Usuario> createUser(Usuario user) async {
    try {
      final response = await dio.post(
        '$apiUrl/auth/register',
        data: user.toJson(),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception(response.data.toString());
      }

      return Usuario.fromJson(response.data);
    } catch (e) {
      throw Exception("Dados inválidos. Tente novamente. ${e.toString()}");
    }
  }

  Future<Usuario> updateUser(Usuario user, String matricula) async {
    final response = await dio.put(
      '$apiUrl/usuario/update/$matricula',
      data: user.toJson(),
    );
    return Usuario.fromJson(response.data);
  }

  Future<void> deleteUser(String matricula) async {
    final response = await dio.delete('$apiUrl/usuario/delete/$matricula');
    return response.data;
  }

  //COORDENADOR
  Future<Usuario> createCoord(Usuario coordenador) async {
    try {
      final response = await dio.post(
        '$apiUrl/coord',
        data: coordenador.toJson(),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception(response.data.toString());
      }

      return Usuario.fromJson(response.data);
    } catch (e) {
      throw Exception("Dados inválidos. Tente novamente. ${e.toString()}");
    }
  }

  Future<String> definirTecnico(String usuarioMatricula) async {
    await dio.put('$apiUrl/coord/definir-tecnico/$usuarioMatricula');
    return "Usuario $usuarioMatricula foi definido como tecnico";
  }

  Future<String> enviarLogin(String coordenadorMatricula) async {
    await dio.get('$apiUrl/coord/getLogin/$coordenadorMatricula');
    return "O login foi enviado para o seu email.";
  }
}
