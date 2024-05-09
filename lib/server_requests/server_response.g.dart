part of 'server_response.dart';

ServerResponse _$ServerResponseFromJson(Map<String, dynamic> json) => ServerResponse(
    environment: json['environment'] as String,
    success: json['success'] as bool,
    code: json['code'] as int,
    message: json['message'] as String,
);