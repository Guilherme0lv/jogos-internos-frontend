import 'package:dio/dio.dart';
import 'package:projeto_web/models/evento.dart';

class EventoService {
  final Dio dio;
  final String apiUrl;

  EventoService({required this.dio, required this.apiUrl});

  //CRUD EVENTO
  Future<Evento> createEvento(Evento evento) async {
    final response = await dio.post(apiUrl, data: evento.toJson());
    return Evento.fromJson(response.data);
  }

  Future<List<Evento>> getEventos() async {
    final response = await dio.get(apiUrl);
    if (response.statusCode == 200) {
      return (response.data as List).map((e) => Evento.fromJson(e)).toList();
    } else {
      throw Exception("Erro ao buscar evento");
    }
  }

  Future<Evento> updateEvento(Evento evento, String tipoEvento) async {
    final response = await dio.put(
      '$apiUrl/update/$tipoEvento',
      data: evento.toJson(),
    );
    return Evento.fromJson(response.data);
  }

  Future<String> deleteEvento(String tipoEvento) async {
    final response = await dio.delete('$apiUrl/delete/$tipoEvento');
    return response.data;
  }
}
