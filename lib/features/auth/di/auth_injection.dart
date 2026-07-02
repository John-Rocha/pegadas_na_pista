import 'package:get_it/get_it.dart';

import '../data/datasources/auth_remote_datasource.dart';
import '../data/repositories/auth_repository_impl.dart';
import '../domain/repositories/auth_repository.dart';
import '../domain/usecases/get_current_user.dart';
import '../domain/usecases/login.dart';
import '../domain/usecases/logout.dart';
import '../presentation/cubit/auth_cubit.dart';

void initAuthDependencies(GetIt sl) {
  sl
    ..registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(dio: sl()),
    )
    ..registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(remoteDataSource: sl(), tokenStorage: sl()),
    )
    ..registerLazySingleton(() => Login(repository: sl()))
    ..registerLazySingleton(() => Logout(repository: sl()))
    ..registerLazySingleton(() => GetCurrentUser(repository: sl()))
    ..registerFactory(
      () => AuthCubit(login: sl(), logout: sl(), getCurrentUser: sl()),
    );
}
