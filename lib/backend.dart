/// Simplified handling of different types of backends (v1, v1, proxied, ecc) based on environment  
class BackendHttp {
  final String? name;
  final String apiHost;
  final String apiRootUrl;

  const BackendHttp(
      {this.name, required this.apiHost, required String pathToApiRoot})
      : apiRootUrl = '$apiHost/$pathToApiRoot';

  @override
  String toString() {
    return 'BackendApi{name: $name, apiRootUrl: $apiRootUrl}';
  }

  static const devHost = 'https://api-prod.joyflo.com';

  static const v1ApiRoot = 'api/v1';

  static const devCore_v1 = BackendHttp(
    name: 'v1 dev',
    apiHost: devHost,
    pathToApiRoot: v1ApiRoot,
  );
}

class Backend {
  final BackendHttp coreApi;

  const Backend({required this.coreApi});

  static const dev = Backend(
    coreApi: BackendHttp.devCore_v1,
  );

  static final Backend current = dev; //hardcoded at dev for this exercise.
}
