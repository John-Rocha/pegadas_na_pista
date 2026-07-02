import 'authenticated_user_model.dart';

class LoginResponseModel {
  const LoginResponseModel({
    required this.accessToken,
    required this.refreshToken,
    required this.usuario,
  });

  final String accessToken;
  final String refreshToken;
  final AuthenticatedUserModel usuario;

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) =>
      LoginResponseModel(
        accessToken: json['accessToken'] as String,
        refreshToken: json['refreshToken'] as String,
        usuario: AuthenticatedUserModel.fromJson(
          json['usuario'] as Map<String, dynamic>,
        ),
      );
}
