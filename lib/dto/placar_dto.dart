class PlacarDTO {
  final int idJogo;
  final int placarA;
  final int placarB;

  PlacarDTO({
    required this.idJogo,
    required this.placarA,
    required this.placarB,
  });

  factory PlacarDTO.fromJson(Map<String, dynamic> json) {
    return PlacarDTO(
      idJogo: json['idJogo'] as int,
      placarA: json['placarA'] as int,
      placarB: json['placarB'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {'idJogo': idJogo, 'placarA': placarA, 'placarB': placarB};
  }
}
