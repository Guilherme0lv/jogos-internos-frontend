import 'package:flutter/material.dart';
import 'package:projeto_web/models/classificacao.dart';
import 'package:projeto_web/models/grupo.dart';
import 'package:projeto_web/services/grupo_service.dart';

class GrupoController extends ChangeNotifier {
  final GrupoService grupoService;
  GrupoController({required this.grupoService});

  List<Grupo> grupos = [];
  bool isLoading = false;

  Future<List<Grupo>> getGrupos() async {
    return await grupoService.getGrupos();
  }

  Future<List<Grupo>> getGruposByEsporte(String nomeEsporte) async {
    return await grupoService.getGruposByEsporte(nomeEsporte);
  }

  Future<List<Classificacao>> getClassificacao(String nomeGrupo) async {
    return await grupoService.getClassificacao(nomeGrupo);
  }

  Future<String> gerarGrupos(String esporteNome) async {
    try {
      final response = await grupoService.gerarGrupos(esporteNome);
      grupos.addAll(response); 
      notifyListeners();

      return "Grupos gerados com sucesso";
    } catch (e) {
      throw Exception("Dados inválidos. Tente novamente. ${e.toString()}");
    } finally {
      notifyListeners();
    }
  }

  Future<void> deleteGrupoByEsporte(String nomeEsporte) async {
    try {
      await grupoService.deleteGrupoByEsporte(nomeEsporte);
      grupos.removeWhere((e) => e.nome == nomeEsporte);
    } catch (e) {
      throw Exception(e.toString());
    } finally {
      notifyListeners();
    }
  }
}
