import 'package:dio/dio.dart';
import 'package:projeto_web/models/equipe.dart';

class EquipeService {
  final Dio dio;
  final String apiUrl;

  EquipeService({required this.dio, required this.apiUrl});

  Future<Equipe> createEquipe(Equipe esporte) async {
    try {
      final response = await dio.post(apiUrl, data: esporte.toJson());

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception(response.data.toString());
      }

      return Equipe.fromJson(response.data);
    } catch (e) {
      throw Exception("Dados inválidos. Tente novamente. ${e.toString()}");
    }
  }

  Future<List<Equipe>> getEquipes() async {
    final response = await dio.get(apiUrl);
    if (response.statusCode == 200) {
      return (response.data as List).map((e) => Equipe.fromJson(e)).toList();
    } else {
      throw Exception("Erro ao buscar equipes");
    }
  }

  Future<List<Equipe>> getEquipesByEsporte(String nomeEsporte) async {
    final encoded = Uri.encodeComponent(nomeEsporte);
    final response = await dio.get(
      '$apiUrl/buscar-por-esporte/$encoded',
    );
    if (response.statusCode == 200) {
      return (response.data as List).map((e) => Equipe.fromJson(e)).toList();
    } else {
      throw Exception("Erro ao buscar equipes");
    }
  }

  Future<Equipe> updateEquipe(Equipe equipe, String nome) async {
    final response = await dio.put(
      '$apiUrl/update/$nome',
      data: equipe.toJson(),
    );
    return Equipe.fromJson(response.data);
  }

  Future<String> deleteEquipe(String nome) async {
    final response = await dio.delete('$apiUrl/delete/$nome');
    return response.data;
  }
}
