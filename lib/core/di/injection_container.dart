import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';

import '../../features/auth/di/auth_injection.dart';
import '../../features/trail/di/trail_injection.dart';
import '../auth/auth_token_storage.dart';
import '../database/database_helper.dart';
import '../location/location_service.dart';
import '../media/media_service.dart';
import '../network/api_client.dart';
import '../network/auth_interceptor.dart';
import '../network/network_info.dart';
import '../permissions/permission_service.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  sl
    ..registerLazySingleton(DatabaseHelper.new)
    ..registerLazySingleton(LocationService.new)
    ..registerLazySingleton(PermissionService.new)
    ..registerLazySingleton(() => MediaService(picker: ImagePicker()))
    ..registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImpl(connectivity: Connectivity()),
    )
    ..registerLazySingleton<FlutterSecureStorage>(
      () => const FlutterSecureStorage(),
    )
    ..registerLazySingleton(() => AuthTokenStorage(secureStorage: sl()))
    ..registerLazySingleton(() => AuthInterceptor(tokenStorage: sl()))
    ..registerLazySingleton(
      () => ApiClient(baseUrl: kApiBaseUrl, authInterceptor: sl()),
    )
    ..registerLazySingleton<Dio>(() => sl<ApiClient>().dio);

  initAuthDependencies(sl);
  initTrailDependencies(sl);
}
