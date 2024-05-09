import 'package:get_it/get_it.dart';

import '../backend.dart';
import '../server_requests/core/http_requests_core.dart';

GetIt getIt = GetIt.instance;

void setUpLocator() {
  final backend = Backend.current;
  getIt
    .registerSingleton(
      HttpRequestsCore.fromApi(backend.coreApi),
    );
}
