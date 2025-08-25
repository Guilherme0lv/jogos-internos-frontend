class Classificacao {
  final int posicao;
  final String nomeEquipe;
  final int pontos;
  final int vitorias;
  final int derrotas;

  Classificacao({
    required this.posicao,
    required this.nomeEquipe,
    required this.pontos,
    required this.vitorias,
    required this.derrotas,
  });

  factory Classificacao.fromJson(Map<String, dynamic> json) {
    return Classificacao(
      posicao: json['posicao'] ?? 0,
      nomeEquipe: json['nomeEquipe'] ?? '',
      pontos: json['pontos'] ?? 0,
      vitorias: json['vitorias'] ?? 0,
      derrotas: json['derrotas'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'posicao': posicao,
      'nomeEquipe': nomeEquipe,
      'pontos': pontos,
      'vitorias': vitorias,
      'derrotas': derrotas,
    };
  }


}
