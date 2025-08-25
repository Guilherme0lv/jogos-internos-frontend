class Curso {
   final String nome;
   final String tipoCurso;

  Curso({required this.nome, required this.tipoCurso});

  factory Curso.fromJson(Map<String, dynamic> json) {
    return Curso(
      nome: json['nome']?.toString() ?? '',
      tipoCurso: json['tipoCurso']?.toString() ?? '',
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'tipoCurso': tipoCurso,
    };
  }
}
