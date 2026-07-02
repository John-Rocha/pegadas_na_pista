import '../../domain/entities/authenticated_user.dart';

class AuthenticatedUserModel extends AuthenticatedUser {
  const AuthenticatedUserModel({
    required super.id,
    required super.nome,
    required super.email,
    required super.perfil,
  });

  factory AuthenticatedUserModel.fromJson(Map<String, dynamic> json) =>
      AuthenticatedUserModel(
        id: json['idUsuario'] as String,
        nome: json['nome'] as String,
        email: json['email'] as String,
        perfil: json['perfil'] as String,
      );

  Map<String, dynamic> toJson() => {
    'idUsuario': id,
    'nome': nome,
    'email': email,
    'perfil': perfil,
  };
}
