class Grupo {
  final String nome;
  final String esporteNome;
  final List<String> equipes;
  final List<String> jogos;

  Grupo({
    required this.nome,
    required this.esporteNome,
    required this.equipes,
    required this.jogos,
  });

  factory Grupo.fromJson(Map<String, dynamic> json) {
    return Grupo(
      nome: json['nome'] ?? '',
      esporteNome: json['esporteNome'] ?? '',
      equipes: List<String>.from(json['equipes'] ?? []),
      jogos: List<String>.from(json['jogos'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'esporteNome': esporteNome,
      'equipes': equipes,
      'jogos': jogos,
    };
  }
}
