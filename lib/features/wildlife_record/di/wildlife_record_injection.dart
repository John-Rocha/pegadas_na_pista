import 'package:get_it/get_it.dart';

import '../data/datasources/especie_local_datasource.dart';
import '../data/datasources/wildlife_record_local_datasource.dart';
import '../data/repositories/especie_repository_impl.dart';
import '../data/repositories/wildlife_record_repository_impl.dart';
import '../domain/repositories/especie_repository.dart';
import '../domain/repositories/wildlife_record_repository.dart';
import '../domain/usecases/create_wildlife_record.dart';
import '../domain/usecases/get_especies.dart';
import '../domain/usecases/upload_record_photo.dart';
import '../presentation/cubit/wildlife_record_cubit.dart';

void initWildlifeRecordDependencies(GetIt sl) {
  sl
    ..registerLazySingleton<WildlifeRecordLocalDataSource>(
      () => WildlifeRecordLocalDataSourceImpl(databaseHelper: sl()),
    )
    ..registerLazySingleton<EspecieLocalDataSource>(
      EspecieLocalDataSourceImpl.new,
    )
    ..registerLazySingleton<WildlifeRecordRepository>(
      () => WildlifeRecordRepositoryImpl(localDataSource: sl()),
    )
    ..registerLazySingleton<EspecieRepository>(
      () => EspecieRepositoryImpl(localDataSource: sl()),
    )
    ..registerLazySingleton(() => CreateWildlifeRecord(repository: sl()))
    ..registerLazySingleton(() => UploadRecordPhoto(repository: sl()))
    ..registerLazySingleton(() => GetEspecies(repository: sl()))
    ..registerFactory(
      () => WildlifeRecordCubit(
        createWildlifeRecord: sl(),
        uploadRecordPhoto: sl(),
        getEspecies: sl(),
        locationService: sl(),
        mediaService: sl(),
        permissionService: sl(),
      ),
    );
}
