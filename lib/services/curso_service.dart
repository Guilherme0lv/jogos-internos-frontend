import 'package:dio/dio.dart';
import 'package:projeto_web/models/curso.dart';


class CursoService {
  final Dio dio;
  final String apiUrl;

  CursoService({required this.dio, required this.apiUrl});

    Future<Curso> createCurso(Curso curso) async {
    try {
      final response = await dio.post(apiUrl, data: curso.toJson());

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception(response.data.toString());
      }

      return Curso.fromJson(response.data);
    } catch (e) {
      throw Exception("Dados inválidos. Tente novamente. ${e.toString()}");
    }
  }

  Future<List<Curso>> getCursos() async {
    final response = await dio.get(apiUrl);
    if (response.statusCode == 200) {
      return (response.data as List).map((c) => Curso.fromJson(c)).toList();
    } else {
      throw Exception("Erro ao buscar cursos");
    }
  }

  Future<Curso> updateCurso(Curso curso, String nome) async {
    final response = await dio.put(
      '$apiUrl/update/$nome',
      data: curso.toJson(),
    );
    return Curso.fromJson(response.data);
  }

  Future<void> deleteCurso(String nome) async {
    final response = await dio.delete('$apiUrl/delete/$nome');
    return response.data;
  }

}