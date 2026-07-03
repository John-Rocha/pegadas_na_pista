import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';

import '../../features/trail/di/trail_injection.dart';
import '../../features/wildlife_record/di/wildlife_record_injection.dart';
import '../database/database_helper.dart';
import '../location/location_service.dart';
import '../media/media_service.dart';
import '../network/api_client.dart';
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
    ..registerLazySingleton(() => ApiClient(baseUrl: kApiBaseUrl))
    ..registerLazySingleton<Dio>(() => sl<ApiClient>().dio);

  initTrailDependencies(sl);
  initWildlifeRecordDependencies(sl);
}
