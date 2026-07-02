import '../result.dart';

abstract class UseCase<ReturnType, Params> {
  Future<Result<ReturnType>> call(Params params);
}

/// Marker params for use cases that take no arguments.
class NoParams {
  const NoParams();
}
