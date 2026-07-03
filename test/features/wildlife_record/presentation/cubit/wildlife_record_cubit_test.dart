import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pegadas_na_pista/core/errors/failures.dart';
import 'package:pegadas_na_pista/core/location/location_service.dart';
import 'package:pegadas_na_pista/core/media/media_service.dart';
import 'package:pegadas_na_pista/core/permissions/permission_service.dart';
import 'package:pegadas_na_pista/core/result.dart';
import 'package:pegadas_na_pista/features/wildlife_record/domain/entities/especie.dart';
import 'package:pegadas_na_pista/features/wildlife_record/domain/entities/wildlife_record.dart';
import 'package:pegadas_na_pista/features/wildlife_record/domain/entities/wildlife_record_type.dart';
import 'package:pegadas_na_pista/features/wildlife_record/domain/repositories/especie_repository.dart';
import 'package:pegadas_na_pista/features/wildlife_record/domain/repositories/wildlife_record_repository.dart';
import 'package:pegadas_na_pista/features/wildlife_record/domain/usecases/create_wildlife_record.dart';
import 'package:pegadas_na_pista/features/wildlife_record/domain/usecases/get_especies.dart';
import 'package:pegadas_na_pista/features/wildlife_record/domain/usecases/upload_record_photo.dart';
import 'package:pegadas_na_pista/features/wildlife_record/presentation/cubit/wildlife_record_cubit.dart';
import 'package:pegadas_na_pista/features/wildlife_record/presentation/cubit/wildlife_record_state.dart';

class MockWildlifeRecordRepository extends Mock
    implements WildlifeRecordRepository {}

class MockEspecieRepository extends Mock implements EspecieRepository {}

class MockLocationService extends Mock implements LocationService {}

class MockMediaService extends Mock implements MediaService {}

class MockPermissionService extends Mock implements PermissionService {}

class FakePosition extends Fake implements Position {
  @override
  double get latitude => 0.03456789;

  @override
  double get longitude => -51.05678901;

  @override
  double get accuracy => 8.5;
}

class FakeWildlifeRecord extends Fake implements WildlifeRecord {}

void main() {
  late MockWildlifeRecordRepository recordRepository;
  late MockEspecieRepository especieRepository;
  late MockLocationService locationService;
  late MockMediaService mediaService;
  late MockPermissionService permissionService;

  setUpAll(() {
    registerFallbackValue(FakeWildlifeRecord());
  });

  setUp(() {
    recordRepository = MockWildlifeRecordRepository();
    especieRepository = MockEspecieRepository();
    locationService = MockLocationService();
    mediaService = MockMediaService();
    permissionService = MockPermissionService();
  });

  WildlifeRecordCubit buildCubit() => WildlifeRecordCubit(
    createWildlifeRecord: CreateWildlifeRecord(repository: recordRepository),
    uploadRecordPhoto: UploadRecordPhoto(repository: recordRepository),
    getEspecies: GetEspecies(repository: especieRepository),
    locationService: locationService,
    mediaService: mediaService,
    permissionService: permissionService,
  );

  void mockHappyLocationAndEspecies() {
    when(
      () => permissionService.requestLocationPermission(),
    ).thenAnswer((_) async => const Success(null));
    when(
      () => locationService.getCurrentPosition(),
    ).thenAnswer((_) async => Success(FakePosition()));
    when(
      () => especieRepository.getEspecies(),
    ).thenAnswer((_) async => const Success(<Especie>[]));
  }

  blocTest<WildlifeRecordCubit, WildlifeRecordState>(
    'emits [LoadingLocation, FormEditing] when initializeForm succeeds',
    setUp: mockHappyLocationAndEspecies,
    build: buildCubit,
    act: (cubit) => cubit.initializeForm(WildlifeRecordType.sighting),
    expect: () => [
      const WildlifeRecordLoadingLocation(),
      isA<WildlifeRecordFormEditing>(),
    ],
  );

  blocTest<WildlifeRecordCubit, WildlifeRecordState>(
    'emits [LoadingLocation, Error] when location permission denied',
    setUp: () =>
        when(
          () => permissionService.requestLocationPermission(),
        ).thenAnswer(
          (_) async => const Error(PermissionFailure('Permissão negada.')),
        ),
    build: buildCubit,
    act: (cubit) => cubit.initializeForm(WildlifeRecordType.sighting),
    expect: () => [
      const WildlifeRecordLoadingLocation(),
      isA<WildlifeRecordError>(),
    ],
  );

  blocTest<WildlifeRecordCubit, WildlifeRecordState>(
    'emits [Submitting, Success] when submit succeeds without photos',
    setUp: () {
      mockHappyLocationAndEspecies();
      when(() => recordRepository.createRecord(any())).thenAnswer(
        (invocation) async =>
            Success(invocation.positionalArguments.first as WildlifeRecord),
      );
    },
    build: buildCubit,
    act: (cubit) async {
      await cubit.initializeForm(WildlifeRecordType.sighting);
      await cubit.submit();
    },
    skip: 2,
    expect: () => [
      const WildlifeRecordSubmitting(),
      isA<WildlifeRecordSuccess>(),
    ],
  );

  blocTest<WildlifeRecordCubit, WildlifeRecordState>(
    'emits [Submitting, Error] when submit fails',
    setUp: () {
      mockHappyLocationAndEspecies();
      when(() => recordRepository.createRecord(any())).thenAnswer(
        (_) async => const Error(ServerFailure('Erro no servidor.')),
      );
    },
    build: buildCubit,
    act: (cubit) async {
      await cubit.initializeForm(WildlifeRecordType.sighting);
      await cubit.submit();
    },
    skip: 2,
    expect: () => [
      const WildlifeRecordSubmitting(),
      isA<WildlifeRecordError>(),
    ],
  );
}
