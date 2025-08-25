class LoginDTO {
  final String matricula;
  final String senha;

  LoginDTO({
    required this.matricula,
    required this.senha,
  });

  
  Map<String, dynamic> toJson() {
    return {
      'matricula': matricula,
      'senha': senha,
    };
  }

}