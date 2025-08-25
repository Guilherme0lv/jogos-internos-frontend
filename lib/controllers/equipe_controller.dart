import 'package:flutter/material.dart';
import 'package:projeto_web/models/equipe.dart';
import 'package:projeto_web/services/equipe_service.dart';

class EquipeController extends ChangeNotifier {
  final EquipeService equipeService;
  EquipeController({required this.equipeService});

  List<Equipe> equipes = [];
  bool isLoading = false;


  Future<void> fetchEquipes() async {
    equipes = await equipeService.getEquipes();
    notifyListeners();
  }

  Future<List<Equipe>> getEquipes() async {
    return await equipeService.getEquipes();
  }

  Future<List<Equipe>> getEquipesByEsporte(String nomeEsporte) async {
    return await equipeService.getEquipesByEsporte(nomeEsporte);
  }
 
  Future<void> createEquipe(Equipe equipe) async {
    try {
      final newEquipe = await equipeService.createEquipe(equipe);
      equipes.add(newEquipe);
      notifyListeners();
     
    } catch (e) {
      throw Exception("Dados inválidos. Tente novamente. ${e.toString()}");
    }
    finally {
      notifyListeners();
    }
  }

  Future<void> updateEquipe(Equipe equipe, String nome) async {
    final updated = await equipeService.updateEquipe(equipe, nome);
    final index = equipes.indexWhere((e) => e.nome == nome);
    if (index != -1) {
      equipes[index] = updated;
      notifyListeners();
    }
  }

  Future<void> removeEquipe(String nomeEquipe) async {
    try {
      await equipeService.deleteEquipe(nomeEquipe);
      equipes.removeWhere((e) => e.nome == nomeEquipe);
    } catch (e) {
      debugPrint("Erro ao deletar curso: $e");
    } finally {
      notifyListeners();
    }
  }
}