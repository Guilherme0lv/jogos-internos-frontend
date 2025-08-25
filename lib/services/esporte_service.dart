import 'package:dio/dio.dart';
import 'package:projeto_web/models/esporte.dart';

class EsporteService {
  final Dio dio;
  final String apiUrl;

  EsporteService({required this.dio, required this.apiUrl});

    Future<Esporte> createEsporte(Esporte esporte) async {
    try {
      final response = await dio.post(
        apiUrl,
        data: esporte.toJson(),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception(response.data.toString());
      }

      return Esporte.fromJson(response.data);
    } catch (e) {
      throw Exception("Dados inválidos. Tente novamente. ${e.toString()}");
    }
  }

  Future<List<Esporte>> getEsporte() async {
    final response = await dio.get(apiUrl);
    if (response.statusCode == 200) {
      return (response.data as List).map((e) => Esporte.fromJson(e)).toList();
    } else {
      throw Exception("Erro ao buscar esporte");
    }
  }

  Future<Esporte> updateEsporte(Esporte esporte, String nome) async {
    final response = await dio.put(
      '$apiUrl/update/$nome',
      data: esporte.toJson(),
    );
    return Esporte.fromJson(response.data);
  }

  Future<void> deleteEsporte(String nome) async {
    final response = await dio.delete('$apiUrl/delete/$nome');
    return response.data;
  }


}