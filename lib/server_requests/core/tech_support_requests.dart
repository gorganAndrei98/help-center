import 'package:flu/data_models/tech_support_question.dart';
import 'package:flu/server_requests/http_requests_manager.dart';
import 'package:flu/server_requests/urls.dart';
import 'package:flu/server_requests/utils/api_utils.dart';

import '../server_response.dart';

class TechSupportRequests {
  final HttpRequestsManager _http;
  
  TechSupportRequests(this._http);
  
  Future<ServerResponse> postSupportRequest(TechSupportQuestion supportRequest) async {
    final res = await _http.postRequest(Urls.urlSupport, supportRequest.toJson());
    return res.extractQueryResponseData().castData((value) => ServerResponse.fromJson(value))[0];
  }

}