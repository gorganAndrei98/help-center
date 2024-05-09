import 'dart:convert';

import 'package:flu/server_requests/query_response.dart';
import 'package:http/http.dart';

extension ExtractFromResponse on Response {
  QueryResponse extractQueryResponseData(){
    return QueryResponse.fromDynamic(jsonDecode(body)['data'] ?? jsonDecode(body));
  }
}