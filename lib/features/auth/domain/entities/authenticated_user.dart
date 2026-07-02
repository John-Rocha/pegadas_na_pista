import 'package:equatable/equatable.dart';

class AuthenticatedUser extends Equatable {
  const AuthenticatedUser({
    required this.id,
    required this.nome,
    required this.email,
    required this.perfil,
  });

  final String id;
  final String nome;
  final String email;
  final String perfil;

  @override
  List<Object?> get props => [id, nome, email, perfil];
}
