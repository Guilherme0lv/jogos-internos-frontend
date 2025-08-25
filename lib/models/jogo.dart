class Jogo {
  final int id;
  final String dataHora;
  final String arbitro;
  final String nomeEquipeA;
  final String nomeEquipeB;
  final int placarEquipeA;
  final int placarEquipeB;
  final String fase;
  final String status;

  Jogo({
    required this.id,
    required this.dataHora,
    required this.arbitro,
    required this.nomeEquipeA,
    required this.nomeEquipeB,
    required this.placarEquipeA,
    required this.placarEquipeB,
    required this.fase,
    required this.status,
  });

  factory Jogo.fromJson(Map<String, dynamic> json) {
    return Jogo(
      id: json['id'] as int,
      dataHora: json['dataHora'] as String,
      arbitro: json['arbitro'] as String,
      nomeEquipeA: json['nomeEquipeA'] as String,
      nomeEquipeB: json['nomeEquipeB'] as String,
      placarEquipeA: json['placarEquipeA'] as int,
      placarEquipeB: json['placarEquipeB'] as int,
      fase: json['fase'] as String,
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dataHora': dataHora,
      'arbitro': arbitro,
      'nomeEquipeA': nomeEquipeA,
      'nomeEquipeB': nomeEquipeB,
      'placarEquipeA': placarEquipeA,
      'placarEquipeB': placarEquipeB,
      'fase' : fase,
      'status': status,
    };
  }
}
