import 'package:flu/backend.dart';
import 'package:flu/server_requests/core/question_type_requests.dart';
import 'package:flu/server_requests/core/tech_support_requests.dart';

import '../http_requests_manager.dart';
import 'feedback_requests.dart';

class HttpRequestsCore {
  final HttpRequestsManager http;

  final FeedbackRequests feedbackRequests;
  final TechSupportRequests techSupportRequests;
  final QuestionTypeRequests questionTypeRequests;

  HttpRequestsCore(this.http)
      : feedbackRequests = FeedbackRequests(http),
        techSupportRequests = TechSupportRequests(http),
        questionTypeRequests = QuestionTypeRequests(http);

  factory HttpRequestsCore.fromApi(BackendHttp api, {bool logRequests = true}) {
    final http = HttpRequestsManager(api.apiRootUrl, logRequests: logRequests);

    return HttpRequestsCore(http);
  }
}
