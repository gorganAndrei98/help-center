import 'dart:convert';
import 'dart:developer';

import 'package:flu/data_models/question_type.dart';
import 'package:flu/server_requests/http_requests_manager.dart';
import 'package:flu/server_requests/urls.dart';
import 'package:flu/server_requests/utils/api_utils.dart';
import 'package:http/http.dart';

class QuestionTypeRequests {
  final HttpRequestsManager _http;

  QuestionTypeRequests(this._http);

  Future<List<QuestionType>> getAll() async {
    Response response = await _http.getRequest(
      Urls.urlQuestionType,
      queryParams: {"type_domain": "TYPE_QUESTION"},
    );
    return response.extractQueryResponseData().castData((value) => QuestionType.fromJson(value)) ?? [];
  }
}
