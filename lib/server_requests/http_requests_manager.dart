import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flu/server_requests/utils/url_query_params.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class HttpRequestsManager {
  final String defaultBaseUrl;
  final bool logRequests;

  HttpRequestsManager(this.defaultBaseUrl, {this.logRequests = true});

  String _getBaseUrl([String? baseUrl]) => baseUrl ?? defaultBaseUrl;

  static String _buildPath(String absolutePath, [Map<String, dynamic>? query]) {
    if (query == null || query.isEmpty) return absolutePath;

    final paramsBuilder = URLQueryParams();

    query.forEach(paramsBuilder.append);

    return '$absolutePath?${paramsBuilder.toString()}';
  }

  @protected
  Future<Map<String, String>> getHeaders(
      [Map<String, String>? overrideHeaders]) async {
    const _defaultHeaders = {HttpHeaders.connectionHeader: 'keep-alive'};

    return overrideHeaders == null || overrideHeaders.isEmpty
        ? _defaultHeaders
        : mergeMaps(_defaultHeaders, overrideHeaders);
  }

  Future<T> _sendRequestGeneral<C, T>({
    required String method,
    required String requestedPath,
    required C Function() openClient,
    required void Function(C? client) closeClient,
    required Future<T> Function(C? client, String url,
            {Map<String, String>? headers})
        send,
    required int? Function(T response) statusCode,
    Map<String, dynamic>? queryParams,
    void Function(String method, String requestedUrl, dynamic exception,
            StackTrace stackTrace,
            {Map<String, String> sentHeaders})?
        logSendException,
  }) async {
    final requestedUrl = _buildPath(requestedPath, queryParams);
    Map<String, String>? inputHeaders = {};
    inputHeaders[HttpHeaders.contentTypeHeader] =
        'application/json'; // hardcoded for the sake of the exercise. Could be passed as a parameter

    final headers = await getHeaders(inputHeaders);
    C? client;
    T response;
    try {
      client = openClient();

      response = await send(client, requestedUrl, headers: headers);
      final statusCodeValue = statusCode(response) ?? 0;
      closeClient(client);
      return response;
    } catch (e, stack) {
      if (logSendException != null) {
        logSendException(method, requestedUrl, e, stack, sentHeaders: headers);
      }
      rethrow;
    } finally {
      if (client != null) {
        closeClient(client);
      }
    }
  }

  Future<Response> _sendRequest({
    required String method,
    required String requestedUrl,
    required Future<Response> Function(Client? client, String url,
            {Map<String, String>? headers})
        send,
    Map<String, dynamic>? queryParams,
  }) {
    return _sendRequestGeneral<Client, Response>(
      method: method,
      requestedPath: requestedUrl,
      openClient: () => Client(),
      closeClient: (client) => client!.close(),
      send: send,
      statusCode: (response) => response.statusCode,
      queryParams: queryParams,
    );
  }

  Future<Response> sendJsonBodyRequest(
    String method,
    String url, {
    String? baseUrl,
    Map<String, dynamic>? queryParams,
    dynamic body,
    Map<String, String>? overrideHeaders,
  }) {
    final requestedUrl = _getBaseUrl(baseUrl) + url;

    String? parsedBody;

    if (body != null) parsedBody = body is String ? body : jsonEncode(body);

    return _sendRequest(
      method: method,
      requestedUrl: requestedUrl,
      send: (client, url, {headers}) async {
        final request = Request(method, Uri.parse(url));
        if (headers != null) request.headers.addAll(headers);
        if (parsedBody != null) request.body = parsedBody;

        final response = await client!.send(request);
        final responseBody = await response.stream.bytesToString();
        return Future.value(
          Response(
            responseBody,
            response.statusCode,
            request: request,
            headers: response.headers,
            isRedirect: response.isRedirect,
            persistentConnection: response.persistentConnection,
            reasonPhrase: response.reasonPhrase,
          ),
        );
      },
      queryParams: queryParams,
    );
  }

  static Future<Response> _get(Client? client, String url, {Map<String, String>? headers}) => client!.get(Uri.parse(url), headers: headers);

  Future<Response> _getRequest(
      String url, {
        String? baseUrl,
        Map<String, dynamic>? queryParams,
        Map<String, String>? overrideHeaders,
      }) {
    const method = 'GET';

    final requestedUrl = _getBaseUrl(baseUrl) + url;

    return _sendRequest(
      method: method,
      requestedUrl: requestedUrl,
      send: _get,
      queryParams: queryParams,
    );
  }

  Future<Response> getRequest(
      String url, {
        String? baseUrl,
        Map<String, dynamic>? queryParams,
        bool returnErrorResponse = false,
        Map<String, String>? overrideHeaders,
      }) {
    return _getRequest(
      url,
      baseUrl: baseUrl,
      queryParams: queryParams,
      overrideHeaders: overrideHeaders,
    );
  }

  Future<Response> patchRequest(
      String url, {
        String? baseUrl,
        dynamic body,
        Map<String, dynamic>? queryParams,
        Map<String, String>? overrideHeaders,
      }) {
    return sendJsonBodyRequest(
      'PATCH',
      url,
      baseUrl: baseUrl,
      body: body,
      queryParams: queryParams,
      overrideHeaders: overrideHeaders,
    );
  }

  Future<Response> postRequest(
      String url,
      dynamic body, {
        String? baseUrl,
        Map<String, String>? queryParams,
        Map<String, String>? overrideHeaders,
      }) {
    return sendJsonBodyRequest(
      'POST',
      url,
      queryParams: queryParams,
      baseUrl: baseUrl,
      body: body,
      overrideHeaders: overrideHeaders,
    );
  }

  Future<Response> putRequest(
      String url,
      dynamic body, {
        String? baseUrl,
        Map<String, String>? overrideHeaders,
      }) {
    return sendJsonBodyRequest(
      'PUT',
      url,
      baseUrl: baseUrl,
      body: body,
      overrideHeaders: overrideHeaders,
    );
  }
}
