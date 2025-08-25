import 'package:flutter/material.dart';
import 'package:projeto_web/models/esporte.dart';
import 'package:projeto_web/services/esporte_service.dart';

class EsporteController extends ChangeNotifier {
  final EsporteService esporteService;
  EsporteController({required this.esporteService});

  List<Esporte> esportes = [];
  bool isLoading = false;

  Future<void> fetchEsportes() async {
    try {
      esportes = await esporteService.getEsporte();
    } catch (e) {
      debugPrint("Erro ao buscar cursos: $e");
      esportes = [];
    }
  }
  Future<List<Esporte>> getEsportes() async {
    return await esporteService.getEsporte();
  }


  Future<void> createEsporte(Esporte esporte) async {
    try {
      final newEsporte = await esporteService.createEsporte(esporte);
      esportes.add(newEsporte);
      notifyListeners();
    } catch (e) {
      throw Exception("Dados inválidos. Tente novamente. ${e.toString()}");
    } finally {
      notifyListeners();
    }
  }

  Future<void> updateEsporte(Esporte esporte, String nomeEsporte) async {
    final updated = await esporteService.updateEsporte(esporte, nomeEsporte);
    final index = esportes.indexWhere((e) => e.nome == nomeEsporte);
    if (index != -1) {
      esportes[index] = updated;
      notifyListeners();
    }
  }

  Future<void> removeEsporte(String nomeEsporte) async {
    try {
      await esporteService.deleteEsporte(nomeEsporte);
      esportes.removeWhere((e) => e.nome == nomeEsporte);
    } catch (e) {
      throw Exception(e.toString());
    } finally {
      notifyListeners();
    }
  }
}
