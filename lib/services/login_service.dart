import 'package:dio/dio.dart';
import 'package:projeto_web/models/usuario.dart';

class LoginService {
  final Dio dio;
  final String apiUrl;

  LoginService({required this.dio, required this.apiUrl});

  Future<Usuario?> login(String matricula, String senha) async {
    final response = await dio.post(
      '$apiUrl/login',
      data: {"matricula": matricula, "senha": senha},
    );

    if (response.statusCode == 200) {
      return Usuario.fromJson(response.data);
    } else {
      return null;
    }
  }
}
