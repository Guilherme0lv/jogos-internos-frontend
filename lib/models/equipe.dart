import 'package:flutter/material.dart';

class Equipe extends ChangeNotifier {
  final String nome;
  final int pontos;
  final int vitorias;
  final int derrotas;
  final String cursoNome;
  final String esporteNome;
  final String campusNome;
  final String tecnicoMatricula;
  final List<String> atletasMatricula;

  Equipe({
    required this.nome,
    this.pontos = 0,
    this.vitorias = 0,
    this.derrotas = 0,
    required this.cursoNome,
    required this.esporteNome,
    required this.campusNome,
    required this.tecnicoMatricula,
    required this.atletasMatricula,
  });

  factory Equipe.fromJson(Map<String, dynamic> json) {
    return Equipe(
      nome: json['nome'],
      pontos: json['pontos'] ?? 0,
      vitorias: json['vitorias'] ?? 0,
      derrotas: json['derrotas'] ?? 0,
      cursoNome: json['cursoNome'],
      esporteNome: json['esporteNome'],
      campusNome: json['campusNome'],
      tecnicoMatricula: json['tecnicoMatricula'],
      atletasMatricula: List<String>.from(json['atletasMatricula'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'pontos': pontos,
      'vitorias': vitorias,
      'derrotas': derrotas,
      'cursoNome': cursoNome,
      'esporteNome': esporteNome,
      'campusNome': campusNome,
      'tecnicoMatricula': tecnicoMatricula,
      'atletasMatricula': atletasMatricula,
    };
  }
}
