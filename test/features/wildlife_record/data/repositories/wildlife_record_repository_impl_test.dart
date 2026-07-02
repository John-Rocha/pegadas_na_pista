import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pegadas_na_pista/core/errors/exceptions.dart';
import 'package:pegadas_na_pista/core/errors/failures.dart';
import 'package:pegadas_na_pista/core/result.dart';
import 'package:pegadas_na_pista/features/wildlife_record/data/datasources/wildlife_record_remote_datasource.dart';
import 'package:pegadas_na_pista/features/wildlife_record/data/models/record_photo_model.dart';
import 'package:pegadas_na_pista/features/wildlife_record/data/models/wildlife_record_model.dart';
import 'package:pegadas_na_pista/features/wildlife_record/data/repositories/wildlife_record_repository_impl.dart';
import 'package:pegadas_na_pista/features/wildlife_record/domain/entities/wildlife_record.dart';
import 'package:pegadas_na_pista/features/wildlife_record/domain/entities/wildlife_record_type.dart';

class MockWildlifeRecordRemoteDataSource extends Mock
    implements WildlifeRecordRemoteDataSource {}

class FakeWildlifeRecordModel extends Fake implements WildlifeRecordModel {}

void main() {
  late MockWildlifeRecordRemoteDataSource remoteDataSource;
  late WildlifeRecordRepositoryImpl repository;

  setUpAll(() {
    registerFallbackValue(FakeWildlifeRecordModel());
  });

  setUp(() {
    remoteDataSource = MockWildlifeRecordRemoteDataSource();
    repository = WildlifeRecordRepositoryImpl(
      remoteDataSource: remoteDataSource,
    );
  });

  final record = WildlifeRecord(
    type: WildlifeRecordType.roadkill,
    dataOcorrencia: DateTime(2026, 7, 2),
    horaOcorrencia: '14:30:00',
    latitude: 0.03456789,
    longitude: -51.05678901,
  );

  group('createRecord', () {
    test('returns created record with id on success', () async {
      when(() => remoteDataSource.createRecord(any())).thenAnswer(
        (_) async => {'idRegistro': 'r1', 'statusValidacao': 'pendente'},
      );

      final result = await repository.createRecord(record);

      expect(result, isA<Success<WildlifeRecord>>());
      expect((result as Success).value.id, 'r1');
    });

    test('returns ServerFailure on ServerException', () async {
      when(
        () => remoteDataSource.createRecord(any()),
      ).thenThrow(ServerException('Erro no servidor.'));

      final result = await repository.createRecord(record);

      expect((result as Error).failure, isA<ServerFailure>());
    });

    test('returns NetworkFailure on NetworkException', () async {
      when(
        () => remoteDataSource.createRecord(any()),
      ).thenThrow(NetworkException('Sem conexão.'));

      final result = await repository.createRecord(record);

      expect((result as Error).failure, isA<NetworkFailure>());
    });
  });

  group('uploadPhoto', () {
    test('returns uploaded photo on success', () async {
      when(
        () => remoteDataSource.uploadPhoto(
          localPath: any(named: 'localPath'),
          tipoFoto: any(named: 'tipoFoto'),
          registroId: any(named: 'registroId'),
        ),
      ).thenAnswer(
        (_) async => const RecordPhotoModel(
          urlFoto: 'https://storage.app/foto1.jpg',
          tipoFoto: 'animal',
        ),
      );

      final result = await repository.uploadPhoto(
        localPath: '/tmp/foto.jpg',
        tipoFoto: 'animal',
      );

      expect(result, isA<Success<dynamic>>());
    });
  });
}
