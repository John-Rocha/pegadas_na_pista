import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthTokenStorage {
  AuthTokenStorage({required this.secureStorage});

  final FlutterSecureStorage secureStorage;

  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';
  static const _userKey = 'auth_user';

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await secureStorage.write(key: _accessTokenKey, value: accessToken);
    await secureStorage.write(key: _refreshTokenKey, value: refreshToken);
  }

  Future<String?> readAccessToken() => secureStorage.read(key: _accessTokenKey);

  Future<String?> readRefreshToken() =>
      secureStorage.read(key: _refreshTokenKey);

  Future<bool> hasValidToken() async => (await readAccessToken()) != null;

  Future<void> saveUserJson(String userJson) =>
      secureStorage.write(key: _userKey, value: userJson);

  Future<String?> readUserJson() => secureStorage.read(key: _userKey);

  Future<void> clearTokens() async {
    await secureStorage.delete(key: _accessTokenKey);
    await secureStorage.delete(key: _refreshTokenKey);
    await secureStorage.delete(key: _userKey);
  }
}
