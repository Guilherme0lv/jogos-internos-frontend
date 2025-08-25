import 'package:dio/dio.dart';
import 'package:projeto_web/models/classificacao.dart';
import 'package:projeto_web/models/grupo.dart';

class GrupoService {
  final Dio dio;
  final String apiUrl;

  GrupoService({required this.dio, required this.apiUrl});

  Future<List<Grupo>> getGrupos() async {
    final response = await dio.get(apiUrl);
    if (response.statusCode == 200) {
      return (response.data as List).map((e) => Grupo.fromJson(e)).toList();
    } else {
      throw Exception("Erro ao buscar grupo");
    }
  }

  Future<List<Grupo>> getGruposByEsporte(String nomeEsporte) async {
    final response = await dio.get('$apiUrl/esporte/$nomeEsporte');
    if (response.statusCode == 200) {
      final List<Grupo> grupos = (response.data as List)
          .map((item) => Grupo.fromJson(item))
          .toList();

      return grupos;
    } else {
      throw Exception("Erro ao buscar grupo");
    }
  }

  Future<List<Classificacao>> getClassificacao(String grupoNome) async {
    final response = await dio.get('$apiUrl/classificacao/$grupoNome');
    if (response.statusCode == 200) {
      return (response.data as List)
          .map((c) => Classificacao.fromJson(c))
          .toList();
    } else {
      throw Exception("Erro ao buscar classificação");
    }
  }

  Future<List<Grupo>> gerarGrupos(String nomeEsporte) async {
    final response = await dio.post('$apiUrl/gerar/$nomeEsporte');
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception("Erro ao gerar grupos: ${response.data}");
    }

    final List<Grupo> grupos = (response.data as List)
        .map((item) => Grupo.fromJson(item))
        .toList();

    return grupos;
  }

  Future<String> deleteGrupoByEsporte(String nomeEsporte) async {
    final response = await dio.delete(
      '$apiUrl/delete-by-esporte/$nomeEsporte',
    );
    return response.data;
  }
}
