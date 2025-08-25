import 'package:dio/dio.dart';
import 'package:projeto_web/models/campus.dart';

class CampusService {
  final Dio dio;
  final String apiUrl;

  CampusService({required this.dio, required this.apiUrl});

  Future<Campus> createCampus(Campus campus) async {
    final response = await dio.post(apiUrl, data: campus.toJson());
    return Campus.fromJson(response.data);
  }

  Future<List<Campus>> getCampus() async {
    final response = await dio.get(apiUrl);
    if (response.statusCode == 200) {
      return (response.data as List).map((c) => Campus.fromJson(c)).toList();
    } else {
      throw Exception("Erro ao buscar esporte");
    }
  }

  Future<Campus> updateCampus(Campus campus, String nomeCampus) async {
    final response = await dio.put(
      '$apiUrl/update/$nomeCampus',
      data: campus.toJson(),
    );
    return Campus.fromJson(response.data);
  }

  Future<String> deleteCampus(String nome) async {
    final response = await dio.delete('$apiUrl/delete/$nome');
    return response.data;
  }
}