class Usuario {
  final String matricula;
  final String senha;
  final String nomeCompleto;
  final String apelido;
  final String telefone;
  final String tipoUsuario;
  final String cursoNome;

  Usuario({
    required this.matricula,
    required this.senha,
    required this.nomeCompleto,
    required this.apelido,
    required this.telefone,
    required this.tipoUsuario,
    required this.cursoNome,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      matricula: json['matricula']?.toString() ?? '',
      nomeCompleto: json['nomeCompleto']?.toString() ?? '',
      senha: json['senha']?.toString() ?? '',
      apelido: json['apelido']?.toString() ?? '',
      telefone: json['telefone']?.toString() ?? '',
      cursoNome: json['cursoNome']?.toString() ?? '',
      tipoUsuario: json['tipoUsuario']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'matricula': matricula,
      'senha': senha,
      'nomeCompleto': nomeCompleto,
      'apelido': apelido,
      'telefone': telefone,
      'tipoUsuario': tipoUsuario,
      'cursoNome': cursoNome,
    };
  }
}
