class Campus {
  final String nome;
  final String cidade;

  Campus({
    required this.nome,
    required this.cidade,
  });

  factory Campus.fromJson(Map<String, dynamic> json) {
    return Campus(
      nome: json['nome'],
      cidade: json['cidade'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'cidade': cidade,
    };
  }
}
