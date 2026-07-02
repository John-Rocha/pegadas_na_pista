import 'package:get_it/get_it.dart';

import '../data/datasources/trail_local_data_source.dart';
import '../data/repositories/trail_repository_impl.dart';
import '../domain/repositories/trail_repository.dart';
import '../domain/usecases/add_trail_point.dart';
import '../domain/usecases/delete_trail.dart';
import '../domain/usecases/get_trails.dart';
import '../domain/usecases/start_trail.dart';
import '../presentation/bloc/trail_bloc.dart';
import '../presentation/cubit/trail_recording_cubit.dart';

void initTrailDependencies(GetIt sl) {
  sl
    ..registerLazySingleton<TrailLocalDataSource>(
      () => TrailLocalDataSourceImpl(databaseHelper: sl()),
    )
    ..registerLazySingleton<TrailRepository>(
      () => TrailRepositoryImpl(localDataSource: sl()),
    )
    ..registerLazySingleton(() => GetTrails(repository: sl()))
    ..registerLazySingleton(() => StartTrail(repository: sl()))
    ..registerLazySingleton(() => AddTrailPoint(repository: sl()))
    ..registerLazySingleton(() => DeleteTrail(repository: sl()))
    ..registerFactory(
      () => TrailBloc(getTrails: sl(), deleteTrail: sl()),
    )
    ..registerFactory(
      () => TrailRecordingCubit(
        startTrail: sl(),
        addTrailPoint: sl(),
        locationService: sl(),
        mediaService: sl(),
        permissionService: sl(),
      ),
    );
}
