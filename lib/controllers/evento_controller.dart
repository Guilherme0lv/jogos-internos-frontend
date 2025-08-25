import 'package:flutter/material.dart';
import 'package:projeto_web/models/evento.dart';
import 'package:projeto_web/services/evento_service.dart';

class EventoController extends ChangeNotifier {
  final EventoService eventoService;
  EventoController({required this.eventoService});

  List<Evento> eventos = [];
  bool isLoading = false;

  Future<void> fetchEventos() async {
    eventos = await eventoService.getEventos();
    notifyListeners();
  }

  Future<List<Evento>> getEventos() async {
    return await eventoService.getEventos();
  }

  Future<void> createEvento(Evento evento) async {
    try {
      final newEvento = await eventoService.createEvento(evento);
      eventos.add(newEvento);
      notifyListeners();
    } catch (e) {
      throw Exception("Dados inválidos. Tente novamente. ${e.toString()}");
    } finally {
      notifyListeners();
    }
  }

  Future<void> updateEvento(Evento evento, String tipoEvento) async {
    final updated = await eventoService.updateEvento(evento, tipoEvento);
    final index = eventos.indexWhere((e) => e.tipoEvento == tipoEvento);
    if (index != -1) {
      eventos[index] = updated;
      notifyListeners();
    }
    notifyListeners();
  }

  Future<void> removeEvento(String tipoEvento) async {
    try {
      await eventoService.deleteEvento(tipoEvento);
      eventos.removeWhere((c) => c.tipoEvento == tipoEvento);
    } catch (e) {
      debugPrint("Erro ao deletar evento: $e");
    } finally {
      notifyListeners();
    }
  }
}
