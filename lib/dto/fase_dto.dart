class FaseDTO {
  final String nomeEsporte;
  final String faseAtual;

  FaseDTO({required this.nomeEsporte, required this.faseAtual});

  factory FaseDTO.fromJson(Map<String, dynamic> json) {
    return FaseDTO(
      nomeEsporte: json['nomeEsporte'] as String,
      faseAtual: json['faseAtual'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'nomeEsporte': nomeEsporte, 'faseAtual': faseAtual};
  }
}
