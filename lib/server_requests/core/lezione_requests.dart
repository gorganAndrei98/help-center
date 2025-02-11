import 'dart:math';
import '../http_requests_manager.dart';

class LezioneRequests {
  final HttpRequestsManager _http;

  LezioneRequests(this._http);

  Future<String> getOne() async {
    return Future.delayed(Duration(seconds: 2)).then((value) => 'ciao');
  }

  Future<int> getRandomInt() async {
    return Future.delayed(Duration(seconds: 2)).then((value) => Random().nextInt(10));
  }
}