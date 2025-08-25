import 'package:flutter/material.dart';
import 'package:projeto_web/dto/fase_dto.dart';
import 'package:projeto_web/dto/placar_dto.dart';
import 'package:projeto_web/models/jogo.dart';
import 'package:projeto_web/services/jogo_service.dart';

class JogoController extends ChangeNotifier {
  final JogoService jogoService;
  JogoController({required this.jogoService});

  List<Jogo> jogos = [];
  bool isLoading = false;

  Future<List<Jogo>> gerarJogos(String nomeGrupo) async {
    try {
      isLoading = true;
      notifyListeners();

      final response = await jogoService.gerarJogos(nomeGrupo);
      jogos.addAll(response);
      notifyListeners();

      return response;
    } catch (e) {
      throw Exception("Erro ao gerar jogos: ${e.toString()}");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<List<Jogo>> getJogos() async {
    try {
      isLoading = true;
      notifyListeners();

      final response = await jogoService.getJogos();
      jogos = response;
      notifyListeners();

      return response;
    } catch (e) {
      throw Exception("Erro ao buscar jogos: ${e.toString()}");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<List<Jogo>> getJogosByGrupo(String grupoNome) async {
    try {
      isLoading = true;
      notifyListeners();

      final response = await jogoService.getJogosByGrupo(grupoNome);
      jogos = response;
      notifyListeners();

      return response;
    } catch (e) {
      throw Exception("Erro ao buscar jogos por grupo: ${e.toString()}");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<List<Jogo>> getJogosByFase(
    String esporteNome,
    String faseAtual,
  ) async {
    try {
      isLoading = true;
      notifyListeners();

      final response = await jogoService.getJogosByFase(esporteNome, faseAtual);
      jogos = response;
      notifyListeners();

      return response;
    } catch (e) {
      throw Exception("Erro ao buscar jogos por fase: ${e.toString()}");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<Jogo> finalizarJogo(PlacarDTO placar) async {
    try {
      final response = await jogoService.finalizarJogo(placar);

      int index = jogos.indexWhere((j) => j.id == placar.idJogo);
      if (index != -1) {
        jogos[index] = response;
        notifyListeners();
      }

      return response;
    } catch (e) {
      throw Exception("Erro ao finalizar jogo: ${e.toString()}");
    }
  }

  Future<Jogo> aplicarWO(int jogoId, String nomeEquipe) async {
    try {
      final response = await jogoService.aplicarWO(jogoId, nomeEquipe);

      int index = jogos.indexWhere((j) => j.id == jogoId);
      if (index != -1) {
        jogos[index] = response;
        notifyListeners();
      }

      return response;
    } catch (e) {
      throw Exception("Erro ao aplicar WO: ${e.toString()}");
    }
  }

  Future<Jogo> desfazerWO(int jogoId) async {
    try {
      final response = await jogoService.desfazerWO(jogoId);

      int index = jogos.indexWhere((j) => j.id == jogoId);
      if (index != -1) {
        jogos[index] = response;
        notifyListeners();
      }

      return response;
    } catch (e) {
      throw Exception("Erro ao desfazer WO: ${e.toString()}");
    }
  }

  Future<String> deleteAllJogosDeGrupo(String nomeGrupo) async {
    try {
      final response = await jogoService.deleteAllJogosDeGrupo(nomeGrupo);
      jogos.removeWhere(
        (j) => j.nomeEquipeA == nomeGrupo || j.nomeEquipeB == nomeGrupo,
      );
      notifyListeners();

      return response;
    } catch (e) {
      throw Exception("Erro ao deletar jogos do grupo: ${e.toString()}");
    }
  }

  Future<String> deleteJogoById(int jogoId) async {
    try {
      final response = await jogoService.deleteJogoById(jogoId);
      jogos.removeWhere((j) => j.id == jogoId);
      notifyListeners();

      return response;
    } catch (e) {
      throw Exception("Erro ao deletar jogo: ${e.toString()}");
    }
  }

  Future<String> gerarEliminatoria(String esporteNome) async {
    final response = await jogoService.gerarEliminatoria(esporteNome);
    return response;
  }

  Future<String> gerarProximaFase(FaseDTO fase) async {
    final response = await jogoService.gerarProximaFase(fase);
    return response;
  }
}