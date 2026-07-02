class LoginRequestModel {
  const LoginRequestModel({required this.email, required this.senha});

  final String email;
  final String senha;

  Map<String, dynamic> toJson() => {'email': email, 'senha': senha};
}
