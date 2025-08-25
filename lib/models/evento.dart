class Evento {
  final String tipoEvento;
  final String dataInicio;
  final String dataFim;

  Evento({
    required this.tipoEvento,
    required this.dataInicio,
    required this.dataFim,
  });

  factory Evento.fromJson(Map<String, dynamic> json) {
    return Evento(
      tipoEvento: json['tipoEvento'] ?? '',
      dataInicio: json['dataInicio'] ?? '',
      dataFim: json['dataFim'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tipoEvento': tipoEvento,
      'dataInicio': dataInicio,
      'dataFim': dataFim,
    };
  }
}
