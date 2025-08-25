import 'package:dio/dio.dart';
import 'package:projeto_web/dto/fase_dto.dart';
import 'package:projeto_web/dto/placar_dto.dart';
import 'package:projeto_web/models/jogo.dart';

class JogoService {
  final Dio dio;
  final String apiUrl;

  JogoService({required this.dio, required this.apiUrl});

  Future<List<Jogo>> gerarJogos(String nomeGrupo) async {
    final response = await dio.post('$apiUrl/jogo/gerarJogos/$nomeGrupo');

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception("Erro ao gerar jogos: ${response.data}");
    }

    final List<Jogo> jogos = (response.data as List)
        .map((item) => Jogo.fromJson(item))
        .toList();

    return jogos;
  }

  Future<List<Jogo>> getJogos() async {
    final response = await dio.get('$apiUrl/jogo');
    if (response.statusCode == 200) {
      return (response.data as List).map((j) => Jogo.fromJson(j)).toList();
    } else {
      throw Exception("Erro ao buscar jogos");
    }
  }

  Future<List<Jogo>> getJogosByGrupo(String grupoNome) async {
    final response = await dio.get('$apiUrl/jogo/grupo/$grupoNome');
    if (response.statusCode == 200) {
      return (response.data as List).map((j) => Jogo.fromJson(j)).toList();
    } else {
      throw Exception("Erro ao buscar jogos");
    }
  }

  Future<List<Jogo>> getJogosByFase(
    String esporteNome,
    String faseAtual,
  ) async {
    final response = await dio.get(
      '$apiUrl/jogo/fase/esporte/$esporteNome',
      queryParameters: {"fase": faseAtual},
    );

    if (response.statusCode == 200) {
      return (response.data as List).map((j) => Jogo.fromJson(j)).toList();
    } else {
      throw Exception("Erro ao buscar jogos");
    }
  }

  Future<Jogo> finalizarJogo(PlacarDTO placar) async {
    final response = await dio.put(
      '$apiUrl/jogo/finalizar',
      data: placar.toJson(),
    );
    return Jogo.fromJson(response.data);
  }

  Future<Jogo> aplicarWO(int jogoId, String nomeEquipe) async {
    final response = await dio.put(
      '$apiUrl/jogo/aplicarWO/$jogoId/equipeWin/$nomeEquipe',
    );
    return Jogo.fromJson(response.data);
  }

  Future<Jogo> desfazerWO(int jogoId) async {
    final response = await dio.put('$apiUrl/jogo/desfazerWO/$jogoId');
    return Jogo.fromJson(response.data);
  }

  Future<String> deleteAllJogosDeGrupo(String esporteNome) async {
    final response = await dio.delete(
      '$apiUrl/jogo/deleteAllJogosGrupo/$esporteNome',
    );
    return response.data;
  }

  Future<String> deleteJogoById(int jogoId) async {
    final response = await dio.delete('$apiUrl/jogo/delete$jogoId');
    return response.data;
  }

  Future<String> gerarEliminatoria(String esporteNome) async {
    final response = await dio.post('$apiUrl/eliminatorias/gerar/$esporteNome');
    return response.data;
  }

  Future<String> gerarProximaFase(FaseDTO fase) async {
    final response = await dio.post(
      '$apiUrl/eliminatorias/gerar/proxima-fase',
      data: fase.toJson(),
    );
    return response.data;
  }
}