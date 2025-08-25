class Esporte {
  final String nome;
  final String evento;
  final int minAtletas;
  final int maxAtletas;
  
  final String campeao;

  Esporte({
    required this.nome,
    required this.evento,
    required this.minAtletas,
    required this.maxAtletas,
    this.campeao = "",
  });

  // Construtor a partir de JSON
  factory Esporte.fromJson(Map<String, dynamic> json) {
    return Esporte(
      nome: json['nome'] ?? '',
      evento: json['evento'] ?? '',
      minAtletas: json['minAtletas'] ?? 0,
      maxAtletas: json['maxAtletas'] ?? 0,
      campeao: json['campeao'] ?? '', 
    );
  }

  // Converter para JSON
  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'evento': evento,
      'minAtletas': minAtletas,
      'maxAtletas': maxAtletas,
      'campeao': campeao,
    };
  }
}