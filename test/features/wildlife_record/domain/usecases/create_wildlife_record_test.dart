import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pegadas_na_pista/core/result.dart';
import 'package:pegadas_na_pista/features/wildlife_record/domain/entities/wildlife_record.dart';
import 'package:pegadas_na_pista/features/wildlife_record/domain/entities/wildlife_record_type.dart';
import 'package:pegadas_na_pista/features/wildlife_record/domain/repositories/wildlife_record_repository.dart';
import 'package:pegadas_na_pista/features/wildlife_record/domain/usecases/create_wildlife_record.dart';

class MockWildlifeRecordRepository extends Mock
    implements WildlifeRecordRepository {}

void main() {
  late MockWildlifeRecordRepository repository;
  late CreateWildlifeRecord usecase;

  setUp(() {
    repository = MockWildlifeRecordRepository();
    usecase = CreateWildlifeRecord(repository: repository);
  });

  final record = WildlifeRecord(
    type: WildlifeRecordType.sighting,
    dataOcorrencia: DateTime(2026, 7, 2),
    horaOcorrencia: '14:30:00',
    latitude: 0.03456789,
    longitude: -51.05678901,
  );

  test('delegates to repository.createRecord', () async {
    when(
      () => repository.createRecord(record),
    ).thenAnswer((_) async => Success(record));

    final result = await usecase(CreateWildlifeRecordParams(record: record));

    expect(result, isA<Success<WildlifeRecord>>());
    verify(() => repository.createRecord(record)).called(1);
  });
}
