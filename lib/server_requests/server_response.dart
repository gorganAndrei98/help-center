part 'server_response.g.dart';

class ServerResponse {
  final String environment;
  final bool success;
  final int code;
  final String message;

  ServerResponse({
    required this.environment,
    required this.success,
    required this.code,
    required this.message,
  });


  @override
  String toString() {
    return 'ServerResponse{environment: $environment, success: $success, code: $code, message: $message}';
  }

  factory ServerResponse.fromJson(Map<String, dynamic> json) => _$ServerResponseFromJson(json);
}
