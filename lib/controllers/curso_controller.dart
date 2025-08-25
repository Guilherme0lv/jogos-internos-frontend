import 'package:flutter/material.dart';
import 'package:projeto_web/models/curso.dart';
import 'package:projeto_web/services/curso_service.dart';

class CursoController extends ChangeNotifier {
  final CursoService cursoService;
  CursoController({required this.cursoService});

  List<Curso> cursos = [];
  bool isLoading = false;


  Future<void> fetchCursos() async {
    cursos = await cursoService.getCursos();
    notifyListeners();
  }
  
  Future<List<Curso>> getCursos() async {
    return await cursoService.getCursos();
  }


  Future<void> createCurso(Curso curso) async {
    try {
      final newCurso = await cursoService.createCurso(curso);
      cursos.add(newCurso);
      notifyListeners();
     
    } catch (e) {
      throw Exception("Dados inválidos. Tente novamente. ${e.toString()}");
    }
    finally {
      notifyListeners();
    }
  }

  Future<void> updateCurso(Curso curso, String nomeCurso) async {
    final updated = await cursoService.updateCurso(curso, nomeCurso);
    final index = cursos.indexWhere((c) => c.nome == nomeCurso);
    if (index != -1) {
      cursos[index] = updated;
      notifyListeners();
    }
  }

  Future<void> removeCurso(String nomeCurso) async {
    try {
      await cursoService.deleteCurso(nomeCurso);
      cursos.removeWhere((c) => c.nome == nomeCurso);
    } catch (e) {
      debugPrint("Erro ao deletar curso: $e");
    } finally {
      notifyListeners();
    }
  }

}
