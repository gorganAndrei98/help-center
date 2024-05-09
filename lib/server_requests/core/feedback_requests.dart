import 'package:flu/server_requests/http_requests_manager.dart';

class FeedbackRequests {
  final HttpRequestsManager _http;

  FeedbackRequests(this._http);

  Future<String> getOne() async {
    return Future.delayed(Duration(seconds: 2)).then((value) => 'ciao');
  }

}