import 'package:flutter/material.dart';
import 'package:projeto_web/services/campus_service.dart';
import '../models/campus.dart';

class CampusController extends ChangeNotifier {
  final CampusService campusService;

  List<Campus> campi = [];

  CampusController({required this.campusService});

  // LISTAR CAMPUS
  Future<void> fetchCampi() async {
    campi = await campusService.getCampus();
    notifyListeners();
  }

  Future<List<Campus>> getCampi() async {
    return await campusService.getCampus();
  }


  // CRIAR CAMPUS
  Future<void> createCampus(Campus campus) async {
    final novo = await campusService.createCampus(campus);
    campi.add(novo);
    notifyListeners();
  }

  // ATUALIZAR CAMPUS
  Future<void> updateCampus(Campus campus, String nomeOriginal) async {
    final atualizado = await campusService.updateCampus(campus, nomeOriginal);
    final index = campi.indexWhere((c) => c.nome == nomeOriginal);
    if (index != -1) {
      campi[index] = atualizado;
      notifyListeners();
    }
  }

  // REMOVER CAMPUS
  Future<void> removeCampus(String nome) async {
    await campusService.deleteCampus(nome);
    campi.removeWhere((c) => c.nome == nome);
    notifyListeners();
  }
}