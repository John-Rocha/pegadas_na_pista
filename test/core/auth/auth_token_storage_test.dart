import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pegadas_na_pista/core/auth/auth_token_storage.dart';

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  late MockFlutterSecureStorage secureStorage;
  late AuthTokenStorage storage;

  setUp(() {
    secureStorage = MockFlutterSecureStorage();
    storage = AuthTokenStorage(secureStorage: secureStorage);
  });

  test('saveTokens writes access and refresh tokens', () async {
    when(
      () => secureStorage.write(
        key: any(named: 'key'),
        value: any(named: 'value'),
      ),
    ).thenAnswer((_) async {});

    await storage.saveTokens(accessToken: 'access', refreshToken: 'refresh');

    verify(
      () => secureStorage.write(key: 'access_token', value: 'access'),
    ).called(1);
    verify(
      () => secureStorage.write(key: 'refresh_token', value: 'refresh'),
    ).called(1);
  });

  test('hasValidToken is true when access token exists', () async {
    when(
      () => secureStorage.read(key: 'access_token'),
    ).thenAnswer((_) async => 'access');

    expect(await storage.hasValidToken(), isTrue);
  });

  test('hasValidToken is false when access token missing', () async {
    when(
      () => secureStorage.read(key: 'access_token'),
    ).thenAnswer((_) async => null);

    expect(await storage.hasValidToken(), isFalse);
  });

  test('clearTokens deletes access, refresh and user keys', () async {
    when(
      () => secureStorage.delete(key: any(named: 'key')),
    ).thenAnswer((_) async {});

    await storage.clearTokens();

    verify(() => secureStorage.delete(key: 'access_token')).called(1);
    verify(() => secureStorage.delete(key: 'refresh_token')).called(1);
    verify(() => secureStorage.delete(key: 'auth_user')).called(1);
  });
}
